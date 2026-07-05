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

## Registro de errores

* No configure la camara en ningún sentido y salieron múltiples errores.
**Solución: Configurar las opciones de la camara.
* No configure las teclas con las que el personaje se debe mover.
**Solución: Añadir las teclas de movimiento en Configuración de proyecto-/Mapa de entradas
---

## Prompts de IA
* quiero hacer proyecto de realidad virtual en godot, como lo puedo hacer para cardboard vr
* como utilizo los gitignore
