# Mostrar una imagen en pantalla

Completa el programa para cargar y mostrar una imagen (PNG) en la ventana. La imagen debe aparecer en el centro de la pantalla.

Edita solo la parte marcada con `TODO`.

## Qué debe hacer tu código

1. Cargar la imagen `imagen_jugador.png` que está en la misma carpeta usando `IMG_Load`.
2. Convertir la superficie en textura usando `SDL_CreateTextureFromSurface`.
3. Consultar el ancho y alto de la imagen para centrarla en la ventana (800x600).
4. Dibujar la textura en el centro usando `SDL_RenderCopy`.
5. Presentar el resultado y esperar 3 segundos antes de salir.

## Entrada

Ninguna. La imagen se carga y muestra solita.

## Salida

Se debe ver la imagen `imagen_jugador.png` centrada en la ventana blanca. Después de 3 segundos, el programa cierra automáticamente.

## Ejemplo

Al empezar, la ventana se ve completamente blanca y luego aparece la imagen en el centro, completamente visible y no recortada.