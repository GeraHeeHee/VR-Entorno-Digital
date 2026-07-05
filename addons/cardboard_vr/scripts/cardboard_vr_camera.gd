class_name CardboardVRCamera extends Camera3D

@export var Active : bool = true
@export_category("Controls PC")
@export var Mouse_Sensitivity_PC : float = 0.003
@export var Speed_PC : float = 4.0

@export_category("Controls Movil")
@export var GysroscopeFactor : float = 1.0 # Factor 1.0 para rotación natural
@export var RotateParent : bool = true
@export_category("Movement Movil")
@export var Speed_Movil : float = 3.0 

@export_category("Eyes")
@export_range(0.1, 2.0) var EyesSeparation : float = 2
@export_range(0, 5.0) var EyeHeight : float =  0.8
@export_range(-360, 360) var EyeConvergencyAngle : float =  3

var viewScene = preload("res://addons/cardboard_vr/scenes/CardboardView.tscn")
var left_camera_3d: Camera3D = Camera3D.new()
var right_camera_3d: Camera3D = Camera3D.new()
var LeftEyePivot : Node3D = Node3D.new()
var RightEyePivot : Node3D = Node3D.new()
var View : CardboardView
var LeftEyeSubViewPort : SubViewport = SubViewport.new()
var RightEyeSubViewPort : SubViewport = SubViewport.new()
var parent : Node3D 

func _ready() -> void:      
	parent = get_parent()
	LeftEyePivot.add_child(left_camera_3d)
	LeftEyeSubViewPort.add_child(LeftEyePivot)
	RightEyePivot.add_child(right_camera_3d)    
	RightEyeSubViewPort.add_child(RightEyePivot)    
	View = viewScene.instantiate()
	add_child(View)
	add_child(LeftEyeSubViewPort)
	add_child(RightEyeSubViewPort)  
	View.SetViewPorts(LeftEyeSubViewPort, RightEyeSubViewPort)   
	left_camera_3d.position.x = -(EyesSeparation)
	right_camera_3d.position.x = EyesSeparation        
	LeftEyePivot.position.y = EyeHeight
	RightEyePivot.position.y = EyeHeight
	left_camera_3d.rotate_object_local(Vector3.UP, deg_to_rad(EyeConvergencyAngle))
	right_camera_3d.rotate_object_local(Vector3.UP, -deg_to_rad(EyeConvergencyAngle))

	if OS.get_name() != "Android":
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		# Forzar a Android a procesar los sensores inmediatamente sin retrasos
		Input.set_use_accumulated_input(false)

func _input(event: InputEvent) -> void:
	if not Active or parent == null:
		return
		
	# === MOUSE EN PC (Para que sigas probando en la computadora) ===
	if OS.get_name() != "Android" and event is InputEventMouseMotion:
		var mov_x = -event.relative.x * Mouse_Sensitivity_PC
		var mov_y = -event.relative.y * Mouse_Sensitivity_PC
		
		LeftEyePivot.rotate_y(mov_x)
		RightEyePivot.rotate_y(mov_x)
		LeftEyePivot.rotate_object_local(Vector3.RIGHT, mov_y)
		RightEyePivot.rotate_object_local(Vector3.RIGHT, mov_y)
		
		LeftEyePivot.rotation.x = clamp(LeftEyePivot.rotation.x, deg_to_rad(-85), deg_to_rad(85))
		RightEyePivot.rotation.x = clamp(RightEyePivot.rotation.x, deg_to_rad(-85), deg_to_rad(85))
		
		if Input.is_action_just_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:    
	if not Active or parent == null:
		return
		
	# Sincronizar posición con el nodo padre
	LeftEyePivot.global_position = Vector3(parent.global_position.x, parent.global_position.y + EyeHeight, parent.global_position.z )
	RightEyePivot.global_position = Vector3(parent.global_position.x, parent.global_position.y + EyeHeight, parent.global_position.z )   
	
	# === 1. ROTACIÓN EN MÓVIL POR MOVIMIENTO REAL DEL TELÉFONO ===
	if OS.get_name() == "Android":
		var gyro = Input.get_gyroscope()
		
		# HÍBRIDO CON ACELERÓMETRO: Si el giroscopio directo da cero por restricciones de HyperOS
		if gyro == Vector3.ZERO:
			var grav = Input.get_gravity()
			# Usamos la fuerza gravitacional para mover los pivotes suavemente
			var rot_y_grav = -grav.x * delta * 0.8
			var rot_x_grav = -grav.z * delta * 0.8
			
			if RotateParent:
				parent.rotate_y(rot_y_grav)
			LeftEyePivot.rotate_y(rot_y_grav)
			RightEyePivot.rotate_y(rot_y_grav)
			LeftEyePivot.rotate_object_local(Vector3.RIGHT, rot_x_grav)
			RightEyePivot.rotate_object_local(Vector3.RIGHT, rot_x_grav)
		else:
			# Si el giroscopio directo sí responde
			var rot_y = gyro.y * delta * self.GysroscopeFactor * 5.0
			var rot_x = gyro.x * delta * self.GysroscopeFactor * 5.0
			
			if RotateParent:
				parent.rotate_y(rot_y)
			LeftEyePivot.rotate_y(rot_y)
			RightEyePivot.rotate_y(rot_y)
			LeftEyePivot.rotate_object_local(Vector3.RIGHT, rot_x)
			RightEyePivot.rotate_object_local(Vector3.RIGHT, rot_x)
			
		# Evitar que la cámara gire por completo verticalmente y se ponga de cabeza
		LeftEyePivot.rotation.x = clamp(LeftEyePivot.rotation.x, deg_to_rad(-85), deg_to_rad(85))
		RightEyePivot.rotation.x = clamp(RightEyePivot.rotation.x, deg_to_rad(-85), deg_to_rad(85))

	# === 2. TRASLACIÓN: MOVER SÓLO AL TOCAR LA PANTALLA ===
	if OS.get_name() == "Android":
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			# Avanza hacia donde esté apuntando el teléfono basándose en la vista horizontal actual
			var forward_dir = -LeftEyePivot.global_transform.basis.z
			var direccion_suelo = Vector3(forward_dir.x, 0, forward_dir.z).normalized()
			parent.global_position += direccion_suelo * self.Speed_Movil * delta
			
	# === LÓGICA DE MOVIMIENTO EN PC (Flechas o WASD para simular) ===
	else:
		var input_dir = Vector3.ZERO
		if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
			input_dir -= LeftEyePivot.global_transform.basis.z
		if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
			input_dir += LeftEyePivot.global_transform.basis.z
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
			input_dir -= LeftEyePivot.global_transform.basis.x
		if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
			input_dir += LeftEyePivot.global_transform.basis.x
			
		if input_dir != Vector3.ZERO:
			var direccion_suelo = Vector3(input_dir.x, 0, input_dir.z).normalized()
			parent.global_position += direccion_suelo * self.Speed_PC * delta
