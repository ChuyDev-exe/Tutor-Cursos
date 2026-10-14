# Fuentes con SDL2

Completa el programa. Mostrará "Hola SDL" en la pantalla usando SDL_ttf. El andamiaje carga la fuente y configura el renderer; tu trabajo es renderizar el texto y mostrarlo.

Edita solo la parte marcada con `TODO`.

## Qué debe hacer tu código

1. Crea la superficie de texto con `TTF_RenderText_Solid` usando la fuente ya cargada.
2. Convierte la superficie en textura con `SDL_CreateTextureFromSurface`.
3. Dibuja la textura en el renderer con `SDL_RenderCopy`.
4. Llama a `SDL_RenderPresent` al final del bucle.

La fuente `fuente_principal.ttf` se encuentra en la misma carpeta que el ejecutable.

## Entrada

Ninguna. El programa usa una entrada fija: la cadena `"Hola SDL"`.

## Salida

Se debe ver el texto "Hola SDL" en la ventana blanca, posicionado en la esquina superior izquierda (x=10, y=10).

## Ejemplo

La ventana se abre y muestra:

```
+----------------+
| Hola SDL       |
+----------------+
```

Los otros píxeles de la ventana siguen siendo blancos por defecto.