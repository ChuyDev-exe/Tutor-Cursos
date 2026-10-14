# Caja centrada

Los diálogos de confirmación (tipo zenity) son una ventana con borde, un título arriba y un mensaje dentro, **centrada** en la pantalla. Completa la función `caja_modal`.

La entrada trae el tamaño de la pantalla y el texto:

```
<filas> <cols> <titulo> <mensaje>
```

Ejemplo: `10 30 Hola Adios` dibuja, en una pantalla de 10 filas por 30 columnas:

```
····················
····················
·········+-Hola----+
·········|·········|
·········|·Adios···|
·········|·········|
·········+---------+
····················
····················
····················
```

(Los puntos son espacios: la caja empieza en la fila 2, columna 9.)

## Pasos

1. `werase(stdscr); refresh();` para dejar la pantalla en blanco.
2. Calcula el ancho: `max(strlen(titulo), strlen(mensaje)) + 6`, sin bajar de 10. El alto es 5, siempre.
3. Centra con las fórmulas de siempre:
   - `y = (LINES - 5) / 2`
   - `x = (COLS - ancho) / 2`
4. `WINDOW *v = newwin(5, ancho, y, x);` y `box(v, 0, 0);`
5. Título en el borde superior: `mvwprintw(v, 0, 2, titulo);`
6. Mensaje dentro: `mvwprintw(v, 2, 2, mensaje);`
7. `wrefresh(v);` una tecla con `getch()` y `delwin(v);`

Las coordenadas de `mvwprintw` son **relativas a la ventana**: `(0, 2)` es la fila 0 de la caja.

## Entrada
Una línea con `filas cols titulo mensaje` (títulos de una sola palabra).

## Salida
El andamiaje imprime tal cual todas las filas de la pantalla, recortadas a la derecha. La caja se ve en su posición centrada; el borde se dibuja con `+`, `-` y `|`.

## Ejemplo
Entrada: `10 30 Hola Adios\n`  →  Salida (las filas vacías son líneas en blanco):

```
<línea vacía>
<línea vacía>
·········+-Hola----+
·········|·········|
·········|·Adios···|
·········|·········|
·········+---------+
```

Edita solo la función marcada con `TODO`.
