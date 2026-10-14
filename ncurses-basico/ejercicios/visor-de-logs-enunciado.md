# Visor de logs

Estás construyendo el visor de un log del sistema, como `less` o `journalctl`: 25 líneas de eventos cargadas de `logs.txt`, una ventana con borde que muestra 4 de ellas y una barra de estado que dice en qué rango vas. El andamiaje ya ha cargado el fichero en el array `lineas` y te pasa ese array y su tamaño `n` (25).

La pantalla mide 8 filas por 36 columnas. La ventana visora ocupa las filas 0..5 y la barra de estado va en la fila 7 de `stdscr`.

## Qué debe hacer `ver_logs`

1. Crear la ventana con `vista = newwin(6, 35, 0, 0)`.
2. Empezar con `top = 0` (primera línea visible) y repintar en cada vuelta del bucle:
   - borde: `box(vista, 0, 0)`;
   - título `logs` en la fila 0, columna 2 de la ventana (`mvwprintw`);
   - las filas 1 a 4 de la ventana muestran `lineas[top]` a `lineas[top+3]`, escritas en la columna 1 con `mvwprintw(vista, 1 + i, 1, "%s", …)`. **No dibujes líneas más allá de `n`.**
   - barra de estado en `stdscr`: `mvprintw(7, 0, "linea %d-%d de %d", top + 1, fin, n)`, donde `fin` es `top + 4` sin pasar nunca de `n`;
   - `wrefresh(vista); refresh();`.
3. Leer teclas con `getch()`:
   - `j` o `KEY_DOWN`: `top` suma 1, pero nunca más de `n - 4` (21);
   - `k` o `KEY_UP`: `top` resta 1, pero nunca menos de 0;
   - `q` o `ERR`: termina.

El desplazamiento se llama **clamp**: sin él, `top` se sale del array y dibujas líneas que no existen. En una terminal real, con `keypad` activado, también funcionan las flechas; las pruebas usan `j` y `k`.

## Entrada

Teclas pulsadas, por ejemplo `jj`. Si no hay nada, el visor se queda en la primera línea.

## Salida

El andamiaje lee la ventana antes de liberarla e imprime la primera y la última fila visibles, más el texto de la barra de estado recortado:

```
primera=<línea superior visible>
ultima=<línea inferior visible>
estado=<texto de la barra de estado>
```

## Ejemplo

Entrada: `jj`  →  Salida:

```
primera=2026-01-03 10:02 INFO servicio 02
ultima=2026-01-03 10:05 INFO servicio 05
estado=linea 3-6 de 25
```

Edita solo la función marcada con `TODO`.
