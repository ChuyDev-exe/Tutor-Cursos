# 4. Ventanas, subventanas y marcos

## Objetivo

Al terminar este capítulo sabrás dividir la pantalla en varias ventanas con `derwin`, dibujar bordes con caracteres ACS y borrarlas en el orden correcto.

## Mapa del capítulo

- Repaso: `newwin`, `delwin`, `box` y la regla fila-columna.
- `subwin` frente a `derwin`: cuándo usar cada una.
- Limpiar ventanas: `werase`, `wclear`, `wmove`, `wclrtoeol`.
- Líneas y bordes: `mvhline`, `mvvline`, caracteres `ACS_*` y `wborder`.
- Solapamiento: `touchwin` + `wrefresh` para forzar el repintado.
- Eficiencia: `wnoutrefresh` en varias ventanas y un solo `doupdate`.

## Repaso: newwin, delwin, box

Una ventana es un rectángulo con coordenadas propias. Primero el tamaño, después la posición, y siempre **fila antes que columna**:

```c
WINDOW *v = newwin(5, 20, 1, 1);   // 5 filas, 20 columnas, en (y=1, x=1)
box(v, 0, 0);                      // borde por defecto
mvwprintw(v, 2, 2, "Hola");        // relativo a la ventana
wrefresh(v);
delwin(v);                         // libérala cuando ya no la necesites
```

Las funciones llevan `w` (`mvwprintw`, `wrefresh`) y las coordenadas son relativas a la esquina de la ventana.

## Subventanas: subwin frente a derwin

| Función | Origen de las coordenadas | Contenido |
|---|---|---|
| `subwin(pad, f, c, y, x)` | relativo a la **madre** | **compartido** con la madre |
| `derwin(pad, f, c, y, x)` | relativo a la **madre** | **propio** de la hija |

Las dos apuntan a la misma zona de la pantalla, pero solo `derwin` te deja pintar una cosa sin que la madre se entere.

**Regla: usa `derwin` para paneles independientes (tipo tmux). Usa `subwin` solo si quieres ver exactamente lo mismo desde dos sitios.**

```c
WINDOW *izq = derwin(stdscr, 8, 38, 0, 0);    // filas 0..7, columnas 0..37
WINDOW *der = derwin(stdscr, 8, 38, 0, 40);   // mismas filas, a la derecha
```

## Borrar en el orden correcto

`delwin` borra una ventana. Si una ventana fue creada dentro de otra (o con `derwin`/`subwin` sobre ella), **borra primero las hijas y después la madre**. Si borras la madre primero, las hijas quedan apuntando a memoria ya liberada.

```c
delwin(izq);       // primero las hijas
delwin(der);
delwin(madre);     // la madre al final
```

## Limpiar y colocar el cursor

| Función | Qué hace |
|---|---|
| `werase(v)` / `wclear(v)` | borra la ventana entera (la deja llena de espacios) |
| `wmove(v, y, x)` | coloca el cursor dentro de la ventana |
| `wclrtoeol(v)` | borra desde el cursor hasta el final de la fila |

`wclear` además marca la ventana como «muy sucia», así que casi siempre basta `werase`.

## Líneas y bordes con caracteres ACS

Los caracteres `ACS_*` son los símbolos de línea «bonitos» del terminal:

| Carácter | Dibuja |
|---|---|
| `ACS_HLINE` | línea horizontal `─` |
| `ACS_VLINE` | línea vertical `│` |
| `ACS_ULCORNER` | esquina `┌` |
| `ACS_URCORNER`, `ACS_LLCORNER`, `ACS_LRCORNER` | resto de esquinas |

```c
mvhline(3, 1, ACS_HLINE, 32);      // horizontal: fila, columna, carácter, largo
mvvline(1, 0, ACS_VLINE, 10);      // vertical: fila, columna, carácter, alto
```

Y `wborder` dibuja los cuatro bordes de una vez, con un carácter distinto por lado (0,0 = el de por defecto):

```c
wborder(v, 0, 0, 0, 0, 0, 0, 0, 0);                    // igual que box(v, 0, 0)
wborder(v, '|', '|', '-', '-', '+', '+', '+', '+');    // bordes a medida
```

**Nunca compares las celdas de borde con `'-'` o `'|'` literales:** compara con `(celda & A_CHARTEXT) == (ACS_HLINE & A_CHARTEXT)`.

## Solapamiento: quién tapa a quién

Si una ventana se dibuja encima de otra, la de arriba tapa. Si repintas la de abajo, ncurses no siempre sabe que debe volver a enviar esa zona. Fuerza el repintado:

```c
touchwin(v);      // avisa: "esta ventana ha cambiado entera"
wrefresh(v);
```

Alternativa: `werase(v)` + repintar todo + `wrefresh(v)`.

## Eficiencia: wnoutrefresh y doupdate

Con varias ventanas, en vez de un `wrefresh` por cada una (cada uno refresca la pantalla entera), prepara todas en memoria y actualiza la terminal una sola vez:

```c
wnoutrefresh(a);
wnoutrefresh(b);
doupdate();       // un solo envío a la terminal
```

`wrefresh(v)` equivale a `wnoutrefresh(v)` + `doupdate()`.

## Errores típicos

- **Escribir en `stdscr` con coordenadas de ventana**: si la ventana está en la columna 40, `mvwprintw(panel, 1, 1, …)` es la columna 1 **del panel**. Usa siempre la función con `w` y la ventana correcta.
- **Olvidar el `wrefresh` de cada ventana**: los cambios se quedan en memoria y no se ven.
- **`delwin` en orden incorrecto**: borra las hijas antes que la madre.
- **Confundir `subwin` y `derwin`**: si los paneles se pisan al dibujar, te falta un `derwin`.
- **Leer bordes con caracteres literales**: los `ACS_*` no son `-` ni `|`; compara con `ACS_HLINE & A_CHARTEXT`.

## Resumen en 5 puntos

- `derwin` crea un panel con contenido propio; `subwin` comparte el de la madre.
- Borde: `box(v, 0, 0)` o `wborder` con los caracteres que quieras; las líneas sueltas salen con `mvhline`/`mvvline` y `ACS_*`.
- `werase` limpia, `wmove` coloca el cursor, `wclrtoeol` borra hasta el final de fila.
- `delwin` de las hijas antes que la madre; `touchwin` + `wrefresh` para repintar lo que queda debajo.
- Varias ventanas: `wnoutrefresh` en cada una y un solo `doupdate`.

## Qué vas a practicar

- `panel-de-logs`: una vista dividida con dos paneles `derwin`, borde con `box` y título en cada uno.
- `tabla-con-bordes`: una tabla de inventario dibujada con `mvhline`, `mvvline` y caracteres `ACS_*`.
