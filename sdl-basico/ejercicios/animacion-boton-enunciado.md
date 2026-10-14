# Animación de pelota rebotando

Completa el programa para animar una pelota que rebota dentro de la ventana. La pelota debe moverse a velocidad constante y rebotar cuando choca con los bordes.

Edita solo la función `actualizar_animacion` marcada con `TODO`.

## Qué debe hacer `actualizar_animacion`

1. Usa `SDL_GetTicks()` para saber cuántos milisegundos han pasado.
2. Actualiza la posición `x` e `y` de la pelota según el tiempo y la velocidad `VEL = 200` píxeles/segundo.
3. Si la pelota toca el borde izquierdo o derecho, invierte la dirección `velx`.
4. Si la pelota toca el borde superior o inferior, invierte la dirección `vely`.
5. Aplica la velocidad: `x += velx * dt` y `y += vely * dt`, donde `dt = ticks / 1000.0`.

## Restricciones importantes

- Usa aritmética de punto flotante para `dt` (divide `ticks` entre `1000.0`).
- El radio de la pelota es `R = 20`.
- La ventana tiene ancho `ANCHO = 800` y alto `ALTO = 600`.
- No dejes que la pelota se salga de la ventana; invierte la dirección al chocar.

## Entrada

Ninguna. La pelota se anima solita.

## Salida

La pelota debe rebotar dentro de la ventana blanca. Después de 5 segundos el programa cierra automáticamente.

## Ejemplo

Al empezar, la pelota está en el centro (400, 300) y se mueve hacia la derecha y abajo. Al tocar el borde derecho, invierte su dirección horizontal y empieza a moverse a la izquierda.