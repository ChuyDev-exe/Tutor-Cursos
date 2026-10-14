# Panel de logs (vista dividida)

Estás construyendo la vista de un monitor con dos paneles, como una pantalla partida de `tmux`: información a la izquierda y errores a la derecha. Cada panel es una ventana propia creada con `derwin` sobre `stdscr`, así que cada uno tiene su borde, su título y su contenido.

El andamiaje dimensiona la pantalla a 8 filas por 80 columnas y te pasa las líneas de texto ya leídas.

## Qué debe hacer `dibujar_paneles`

1. Crea el panel izquierdo: `derwin(stdscr, 8, 38, 0, 0)` y guárdalo en la variable global `panel_info`.
2. Crea el panel derecho: `derwin(stdscr, 8, 38, 0, 40)` y guárdalo en `panel_err`.
3. Dibuja el borde de cada panel: `box(panel, 0, 0)`.
4. Escribe el título en la fila 0, columna 2 de cada panel: `INFO` a la izquierda, `ERRORES` a la derecha (`mvwprintw`).
5. Copia las líneas de `info` a las filas 1, 2, … del panel izquierdo, columna 1, con `mvwprintw`. Como máximo caben **6 líneas** (filas 1 a 6); las demás se ignoran.
6. Haz lo mismo con `errores` en el panel derecho.
7. Muestra cada panel con `wrefresh`.

**Regla:** usa siempre funciones con `w` y coordenadas relativas al panel (`mvwprintw(panel_info, 1, 1, …)` es la fila 1 del panel, no de la pantalla).

## Entrada

Primero una línea con dos números: cuántas líneas de info y cuántas de errores. Después, las líneas de info y luego las de errores.

```
2 1
arranque ok
cpu 90%
fallo de disco
```

## Salida

El andamiaje vuelve a leer los paneles e imprime dos líneas. El título sale de la fila 0 del panel y el contenido son las filas 1 a 6 sin las que estén vacías, unidas con `;`:

```
info=titulo:<título>;<l1>;<l2>;…
errores=titulo:<título>;<l1>;<l2>;…
```

Si un panel no tiene líneas, su contenido queda vacío (por ejemplo, `errores=titulo:ERRORES;`).

## Ejemplo

Entrada:

```
2 1
arranque ok
cpu 90%
fallo de disco
```

Salida:

```
info=titulo:INFO;arranque ok;cpu 90%
errores=titulo:ERRORES;fallo de disco
```

Edita solo la función marcada con `TODO`.
