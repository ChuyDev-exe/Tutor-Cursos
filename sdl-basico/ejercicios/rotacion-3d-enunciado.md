# Triángulo giratorio en 3D

Completa el programa para dibujar un triángulo que gira en 3D. Los vértices del triángulo estarán en 3D y se proyectarán a la pantalla 2D usando perspectiva cada fotograma.

Edita solo la función `proyectar_y_dibujar` marcada con `TODO`.

## Qué debe hacer `proyectar_y_dibujar`

1. Define los 3 vértices del triángulo en 3D (usando `float x, y, z`).
   - Vértice A: `(0, 100, 200)`
   - Vértice B: `(-80, -80, 200)`
   - Vértice C: `(80, -80, 200)`

2. Para cada vértice, aplica una rotación simple alrededor del eje Y usando el tiempo:
   - `angle = ticks / 1000.0 * 0.5` (medio radian por segundo)
   - `x_rotado = x * cos(angle) - z * sin(angle)`
   - `z_rotado = x * sin(angle) + z * cos(angle)`
   - `y` se mantiene igual

3. Proyecta cada vértice rotado a 2D usando perspectiva con `d = 5`:
   - `inv_z = 1.0 / (z_rotado + d)`
   - `px = x_rotado * inv_z * 10`
   - `py = y_rotado * inv_z * 10`

4. Dibuja el triángulo conectando los puntos proyectados con líneas:
   - `SDL_RenderDrawLine(pincel, px1, py1, px2, py2)` para cada par de aristas (AB, BC, CA).

## Parámetros globales (ya puestos)

- `int d = 5;` (distancia de la cámara, no tocar).
- `SDL_Renderer *pincel;` (ya creado en el andamiaje).
- `int ticks = SDL_GetTicks();` (disponible en el bucle).

## Entrada

Ninguna. El triángulo gira solo.

## Salida

Un triángulo que gira en el centro de la ventana. Las aristas deben ser blancas y visibles sobre el fondo oscuro.

## Ejemplo

Al empezar, verás un triángulo. Pasan los segundos y el triángulo gira lentamente alrededor del eje vertical.