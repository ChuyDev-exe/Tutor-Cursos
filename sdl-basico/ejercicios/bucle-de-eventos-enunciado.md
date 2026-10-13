# Bucle de eventos

Completa la función `procesar_eventos` del script. Es la primera parte del bucle de un juego: leer los eventos y mover al jugador.

El andamiaje ya hace el resto. Convierte las letras de la entrada en pulsaciones de flechas, añade un evento `SDL_QUIT` al final y repite el bucle hasta que `corriendo` vale 0.

Edita solo la función marcada con `TODO`.

## Qué debe hacer `procesar_eventos`

1. Sacar **todos** los eventos pendientes con `SDL_PollEvent`.
2. Con `SDL_QUIT`, poner `*corriendo` a 0.
3. Con `SDL_KEYDOWN`, mover al jugador `PASO` (10) píxeles según la tecla:

| Tecla | Movimiento |
|---|---|
| `SDLK_RIGHT` | `x` + 10 |
| `SDLK_LEFT` | `x` − 10 |
| `SDLK_DOWN` | `y` + 10 |
| `SDLK_UP` | `y` − 10 |

El jugador empieza en `x=100 y=100`. Recuerda: en SDL el eje y crece hacia abajo.

## Entrada
Una línea con letras: `d` (derecha), `a` (izquierda), `s` (abajo) y `w` (arriba). Las demás letras se ignoran.

## Salida
El andamiaje imprime la posición final y si el bucle terminó con `SDL_QUIT`:

```
x=<x> y=<y>
salida: si
```

## Ejemplo
Entrada: `dds`  →  Salida:

```
x=120 y=110
salida: si
```
