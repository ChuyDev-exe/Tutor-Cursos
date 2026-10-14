# 5. Pads: contenido más grande que la pantalla

## Objetivo

Al terminar este capítulo sabrás mostrar en pantalla trozos de un contenido más grande que la terminal (30 líneas en 5 filas) y desplazarte por él con teclas, como hace `less` o `man`.

## Mapa del capítulo

- Por qué una ventana no puede ser más grande que la pantalla
- `newpad`: la ventana que no está pegada a un sitio
- `prefresh`: qué parte del pad va a dónde
- Desplazar el viewport sin repintar a mano
- Subpads y scroll como alternativa
- Errores típicos con pads

## El problema: la ventana no pasa de la pantalla

`newwin` no te deja crear una ventana más grande que la terminal. Si el informe tiene 30 líneas y la pantalla 8, una ventana no basta. ¿Se copia el contenido a mano por trozos? Aburrido y lento. ncurses ya lo resuelve.

## `newpad`: una ventana sin posición

Un pad es como una ventana, pero **no está pegado a una posición de la pantalla**: es una zona de memoria de `filas × columnas` que tú decides qué recorte mostrar.

```c
WINDOW *pad = newpad(30, 15);        // 30 filas, 15 columnas
mvwprintw(pad, 3, 0, "linea 04");    // se dibuja igual que una ventana
waddch(pad, 5, 0, '#');              // mismas funciones con "w"
```

**Regla de oro: un pad no tiene posición fija; tú eliges qué parte se ve.**

## `prefresh`: la ventana al pad

`wrefresh` no sirve en un pad. Para mostrar un pad usas `prefresh`:

```c
prefresh(pad, pminrow, pmincol, sminrow, smincol, smaxrow, smaxcol);
```

| Argumentos | Dicen |
|---|---|
| `pminrow`, `pmincol` | **Qué parte del pad** se muestra (empieza en esa fila/columna del pad) |
| `sminrow`, `smincol`, `smaxrow`, `smaxcol` | **Dónde cae en pantalla** (rectángulo de esquinas) |

```c
// Desde la fila 3 del pad, en la pantalla de (0,0) a (4,14):
// 5 filas y 15 columnas visibles
prefresh(pad, 3, 0, 0, 0, 4, 14);
```

**Regla de oro: `pmin*` = qué parte del pad; `smax*` = dónde cae en pantalla.**

## Desplazar: cambiar `pminrow` y volver a pintar

El scroll no es otra cosa: mueves el origen del recorte y repintas.

```c
int top = 0;
prefresh(pad, top, 0, 0, 0, 4, 14);   // pintar
if (top < 25) top++;                   // 30 líneas - 5 visibles
prefresh(pad, top, 0, 0, 0, 4, 14);   // repintar
```

Dos límites obligatorios: `pminrow` **nunca negativo** y nunca mayor que `alto_pad - alto_viewport`. Si te pasas, el viewport mira filas que no existen y la pantalla sale incompleta.

## Subpads y scroll (mención)

- `subpad(pad, filas, columnas, y, x)` crea un trozo dentro de un pad, con coordenadas relativas al pad.
- `wscrollok(pad, TRUE)` y `wscrl(pad, 1)` hacen que un pad o ventana se desplace solo al desbordarse: útil para logs que solo crecen hacia abajo.

## Cuándo usar pads

| Situación | Ejemplo típico |
|---|---|
| Visor de archivo o log con scroll | `less`, `tail -f` |
| Manual o ayuda larga | `man` |
| Tabla con más columnas que pantalla | visores de CSV |
| Informe de solo lectura | páginas de resultados |

## Errores típicos

- **`wrefresh(pad)` y no ves la región que toca:** en un pad solo vale `prefresh`.
- **`pminrow` fuera de rango** (negativo o pasándose del pad): viewport vacío o cortado. Aplica el clamp.
- **Viewport más grande que el pad:** `prefresh` no puede mostrar lo que no existe. El recorte del pad debe ser igual o menor que el pad.
- **Confundir el orden de `prefresh`:** primero la parte del pad (`pminrow, pmincol`), después el rectángulo de pantalla (`sminrow, smincol, smaxrow, smaxcol`).
- **Olvidar repintar tras mover el scroll:** cambiar `top` solo cambia una variable; sin volver a `prefresh`, la pantalla no se entera.

## Resumen en 5 puntos

- Un pad es una ventana sin posición: `newpad(filas, columnas)`.
- Se dibuja igual que una ventana: `mvwprintw`, `waddch`…
- `prefresh(pad, pminrow, pmincol, sminrow, smincol, smaxrow, smaxcol)` muestra un recorte del pad en un rectángulo de pantalla.
- Desplazar es cambiar `pminrow`/`pmincol` (con clamp) y volver a llamar a `prefresh`.
- `wrefresh` no sirve para pads; usa siempre `prefresh`.

## Qué vas a practicar

- **Visor de informe:** 30 líneas en un pad con viewport de 5 filas y scroll vertical con `j`/`k`.
- **Tabla ancha:** 12 celdas de 4 columnas y scroll horizontal con `l`/`h`.
