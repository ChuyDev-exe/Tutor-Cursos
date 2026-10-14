# Rejilla de apps

Un lanzador tipo rofi o dmenu: seis aplicaciones en una rejilla de 3 columnas, resaltada la seleccionada, que se mueve con teclas y se cierra con Enter o `q`. Completa la función `lanzador`, que devuelve el índice elegido.

La pantalla mide 12 filas por 44 columnas. Con las apps del andamiaje la rejilla queda centrada en vertical (filas 5 y 6) y con las celdas separadas 14 columnas:

```
············································
··terminal······editor········navegador     ← fila 5 (editor resaltada)
··archivos······musica········ajustes       ← fila 6
············································
```

(Cada `·` es un espacio: las apps empiezan en la columna 2, 16 y 30.)

## Pasos

1. Calcula `filas_necesarias = (n + COLS_GRID - 1) / COLS_GRID` (división entera hacia arriba) y `fila_base = (LINES - filas_necesarias) / 2`.
2. Dibuja la rejilla con `for (i = 0; i < n; i++)`:
   - fila = `fila_base + i / COLS_GRID`, columna = `2 + (i % COLS_GRID) * ANCHO_CELDA`
   - la app seleccionada se dibuja con `attron(A_REVERSE)` … `attroff(A_REVERSE)`
   - termina con `refresh()`
3. Lee teclas: `h`/`KEY_LEFT` y `l`/`KEY_RIGHT` cambian la columna; `k`/`KEY_UP` y `j`/`KEY_DOWN` cambian la fila. **Sin salirse**: fila en `0 .. filas_necesarias - 1`, columna en `0 .. COLS_GRID - 1`, y el índice `fila * COLS_GRID + col` siempre menor que `n`.
4. `\n`, `q`, `KEY_ENTER` o `ERR` terminan el bucle y devuelven el índice seleccionada.
5. Cada vez que cambia la selección, vuelve a empezar: `werase(stdscr)` y redibuja toda la rejilla.

En la terminal real las flechas llegan como `KEY_LEFT`… gracias a `keypad`; en las pruebas se usan letras porque por pipe las flechas no se pueden probar. Acepta ambos.

## Entrada
Las teclas pulsadas, hasta `\n`, `q` o el final de la entrada.

## Salida
El andamiaje imprime la app elegida y la posición de la selección:

```
elegida=<nombre de la app>
fila=<fila de la selección>
col=<columna de la selección>
```

## Ejemplo
Entrada: `lll\n`  →  Salida (tres derechas, la columna se queda en 2):

```
elegida=navegador
fila=0
col=2
```

Edita solo la función marcada con `TODO`.
