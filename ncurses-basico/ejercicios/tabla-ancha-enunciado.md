# Tabla ancha

Completa la función `ver_tabla` del script. El andamiaje ya ha creado un pad de 10 filas por 48 columnas con una tabla de 12 columnas: cada celda ocupa 4 columnas y contiene algo como `A0 ` o `F7 ` (letra de columna, fila, espacio). Tu función deja desplazar la vista a izquierda y derecha, como un visor de CSV con más columnas que pantalla.

Edita solo la función marcada con `TODO`.

## Qué debe hacer `ver_tabla`

1. Poner `*izq` a 0 y pintar el viewport la primera vez con `prefresh(pad, 0, *izq, 0, 0, 6, 11)`.
2. Leer teclas con `getch()` en un bucle hasta `q` o hasta `ERR` (fin de la entrada).
3. `l` o `KEY_RIGHT` mueve la vista 4 columnas a la derecha: `*izq` suma 4, pero nunca más de 36 (`48 - 12`).
4. `h` o `KEY_LEFT` mueve 4 columnas a la izquierda: `*izq` resta 4, pero nunca menos de 0.
5. Tras cada tecla, volver a pintar con `prefresh`. **`wrefresh` no sirve en un pad.**

Al llegar al límite derecho solo quedan tres celdas del pad a la vista (`J0`, `K0`, `L0`); el resto se leen vacías.

## Entrada
Teclas pulsadas, por ejemplo `llh`. Si no hay nada, la vista se queda en la columna `A`.

## Salida
El andamiaje imprime la columna del pad que se ve a la izquierda y las 12 celdas de la fila 0 vistas desde ahí, unidas con `|` (las que caen fuera del pad salen vacías):

```
izq=<columna del pad a la izquierda>
cab=<celda0>|<celda1>|…|<celda11>
```

## Ejemplo
Entrada: `lll`  →  Salida:

```
izq=12
cab=D0|E0|F0|G0|H0|I0|J0|K0|L0|||
```
