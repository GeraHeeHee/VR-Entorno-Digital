# Configuración del Entorno de Desarrollo: Cardboard VR en Godot 4

---

## Requisitos 

* **Godot Engine 4.x**
* **Android Build Template** 
* Plugin de Cardboard VR para Godot 4 

---

## Guía de Configuración Paso a Paso

1. En Godot Engine seleccionamos la opción Nuevo Proyecto, le asignamos un nombre y lo creamos.
2. Tuvimos que haber descargado el plugin oficial o compatible de Cardboard VR para Godot 4.
3. En la carpeta de `addons` de Godot se debe extraer el plugin para que sea parte de nuestro proyecto.
4. En Godot crear una escena con el nodo3D (opcional: Podemos utilizar un objeto creado en blender con agarrar y arrastrar su archivo a la ventana de Godot, a la sección de 'Sistema de archivos'.
5. Debemos crear una escena diferente utilizando el CharacterBody3D que será la camara, a dicho nodo se le debe añadir un hijo que será un cardboardVRCamera3D.
6. Antes de terminar se tiene que configurar la camara como el uso del giroscopio o el nombre del input_cancel, junto las teclas de movimiento, activar el plugin de cardboardvr, dispositivos de entrada se activa el giroscopio y por ultimo modificar el código que viene con el archivo descargado de CardboardVR para que utilice las teclas para mover el personaje pero no la camara.
7. Cuando finalicemos, se debe instanciar como escena hija la de la camara dentro del nodo principal.
8. El codigo que venia con el plugin oficial debemos modificarlo para que sea compatible con el giroscopio del telefono.
9. Crear el apk. desde godot, en la pestaña de proyecto--/Exportar, ahí debemos presionar en "Añadir", seleccionamos Android y en la sección de opciones, en la parte de permisos, y en permisos personalizados creamos uno, finalizando con un copia y pega de este codigo "android.permission.HIGH_SAMPLING_RATE_SENSORS"
10. Para terminar, el apk. lo subes a tu telefono (hay diferentes formas de hacerlo pero yo elegí el subirlo por whatsapp y descargarlo desde ahí) y descargar el archivo, como nota final, el telefono probablemente te pondra varias restricciones dependiendo del modelo, debes quitarselas todas y en algúnos casos irte a las configuraciones de la aplicación recien descargada y quitarle restricciones, tambien se deben asegurar que el telefono en cuestión posea giroscopio, si no el juego jamas funcionara.

## Registro de errores

* No configure la camara en ningún sentido y salieron múltiples errores.
**Solución: Configurar las opciones de la camara.
* No configure las teclas con las que el personaje se debe mover.
**Solución: Añadir las teclas de movimiento en Configuración de proyecto-/Mapa de entradas
* La camara no se movia al momento de utilizar el juego en el telefono
**Solución: Usar otro telefono porque el anterior tenia el giroscopio deshabilitado o directamente no integrado
---

## Prompts de IA
* quiero hacer proyecto de realidad virtual en godot, como lo puedo hacer para cardboard vr
* como utilizo los gitignore
* quiero hacer compatible mi proyecto para moviles, ayudame
** sigue sin moverse la camara, sera problema del telefono?
