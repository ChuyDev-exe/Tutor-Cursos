# 8. Geometría, tamaño y layouts

## Objetivo

Al terminar este capítulo sabrás medir la pantalla y las ventanas, centrarlas con una fórmula y recalcular el diseño cuando cambia el tamaño de la terminal.

## Mapa del capítulo

- `getmaxyx`: medir una ventana
- `LINES` y `COLS`: el tamaño de `stdscr`
- La fórmula de centrado que aparece en todos los diálogos
- `resizeterm` y el evento `KEY_RESIZE`
- Dibujar solo dentro de los límites
- Layouts: mitades, tercios, cabecera y barra de estado

## getmaxyx mide la ventana

`getmaxyx(win, y, x)` rellena dos variables con el alto (filas) y el ancho (columnas) de la ventana:

```c
int alto, ancho;
getmaxyx(stdscr, alto, ancho);   // alto = nº de filas, ancho = nº de columnas
mvprintw(alto - 1, 0, "abajo");  // última fila, primera columna
```

**Ojo: es una macro, no una función.** Pásale variables, nunca una expresión con efectos: `getmaxyx(win, y++, x)` se comporta de forma imprevisible.

**Ojo al orden:** `y` recibe el alto y `x` el ancho. No es el orden fila/columna de dibujo.

## LINES, COLS y getbegyx

- `LINES` y `COLS` son el alto y el ancho de `stdscr`. Son variables globales: se leen directamente.
- `getbegyx(win, y, x)` rellena la posición de la esquina superior izquierda de una ventana.

```c
int fy, fx;
getbegyx(ventana, fy, fx);   // ¿dónde está la ventana en la pantalla?
```

## El centrado: una fórmula para todos los diálogos

Para poner un rectángulo de `alto x ancho` en el centro de la pantalla:

```c
int y = (LINES - alto) / 2;
int x = (COLS - ancho) / 2;
WINDOW *v = newwin(alto, ancho, y, x);
```

La división es entera: sobra 1 fila o columna cuando el resto es impar, y sobra a la derecha o abajo. **Esta fórmula aparece en todos los diálogos, menús y cajas de confirmación.** Aprende la de memoria.

## resizeterm y KEY_RESIZE

`resizeterm(filas, columnas)` finge que la terminal mide ese tamaño: actualiza `LINES`, `COLS` y `getmaxyx(stdscr, …)`.

```c
resizeterm(24, 80);   // a partir de aquí, LINES=24 y COLS=80
```

Si el usuario redimensiona la terminal, `getch()` devuelve `KEY_RESIZE`. Lo correcto es **recalcular todo el layout**: vuelve a leer `LINES`/`COLS` y dibuja otra vez.

**No guardes coordenadas en variables globales para siempre:** calcula las posiciones al dibujar, no al arrancar.

## Dibuja solo dentro de los límites

Si te sales de la ventana, muchas funciones devuelven `ERR` y no dibujan: `mvprintw(99, 99, "x")` no hace nada en una pantalla de 24 filas.

```c
int alto, ancho;
getmaxyx(stdscr, alto, ancho);
for (int f = 0; f < alto; f++)      // < alto, no <= alto
    for (int c = 0; c < ancho; c++)
        ...
```

**Regla: las filas van de 0 a `alto - 1` y las columnas de 0 a `ancho - 1`.**

## Layouts: mitades, tercios, cabecera y barra

Con la misma fórmula de centrado construyes cualquier división:

| Deseo | Cómo |
|---|---|
| Dos paneles en horizontal | `ancho / 2` cada uno; el segundo empieza en `ancho / 2` |
| Tres tercios (tipo tmux) | `ancho / 3`, `2 * ancho / 3` |
| Cabecera fija | fila 0, dibujada con `mvprintw(0, 0, …)` |
| Barra de estado | última fila: `LINES - 1` |

**La barra de estado vive en `LINES - 1`:** no dibujes contenido ahí o la taparás.

## Errores típicos

- **El texto aparece en el sitio equivocado:** confundiste el orden de `getmaxyx` (alto, ancho) con el orden de dibujo (fila, columna). Arreglo: guarda el alto en otra variable, por ejemplo `filas`, para no liarte.
- **Funciona en mi terminal y en otra no:** asumiste 80x24. Arreglo: usa `LINES` y `COLS` siempre que puedas.
- **`mvprintw` no dibuja nada:** te saliste de la pantalla y devolvió `ERR`. Arreglo: comprueba el rango con `getmaxyx` antes.
- **Al redimensionar, el diseño se rompe:** guardaste coordenadas fijas. Arreglo: en `KEY_RESIZE`, recalcula con `LINES`/`COLS` y redibuja.
- **La barra de estado desaparece:** dibujaste contenido en `LINES - 1`. Arreglo: reserva esa fila para la barra.

## Resumen en 5 puntos

- `getmaxyx(win, y, x)` rellena alto y ancho; es macro, pasa variables.
- `LINES` y `COLS` son el tamaño de `stdscr`; `getbegyx` da el origen de una ventana.
- Centrado: `y = (LINES - alto) / 2`, `x = (COLS - ancho) / 2`.
- `resizeterm` cambia el tamaño; `KEY_RESIZE` te avisa: recalcula el layout.
- Dibuja dentro de `0 .. alto-1` y `0 .. ancho-1`; la barra de estado va en `LINES - 1`.

## Qué vas a practicar

- **Caja centrada:** un diálogo modal con borde y título que se centra en cualquier tamaño de pantalla (`caja-centrada`).
- **Rejilla de apps:** un lanzador con celdas iguales centrado en vertical, que se mueve con teclas (`rejilla-de-apps`).
