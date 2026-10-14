# 2. El teclado: de una tecla a las flechas

## Objetivo

Al terminar este capítulo sabrás leer cualquier tecla con `getch()`, distinguir letras, flechas y teclas de control, y mover una selección por una lista sin salirte de los límites.

## Mapa del capítulo

- Los tres ajustes de siempre: `cbreak`, `noecho` y `keypad`, y qué pasa si olvidas uno.
- Las flechas llegan como números: `KEY_UP`, `KEY_DOWN`…
- `getch()` devuelve `int`, no `char`.
- Cada ventana tiene su propio `wgetch()` y su propia `keypad`.
- `ungetch()` devuelve una tecla al buffer.
- Por qué las pruebas usan letras y tu terminal usa flechas.

## Los tres ajustes de siempre

Justo después de abrir la pantalla se colocan tres ajustes:

```c
cbreak();               // cada tecla llega al momento, sin esperar a Enter
noecho();               // las teclas no se escriben solas en la terminal
keypad(stdscr, TRUE);   // las flechas llegan como KEY_UP, KEY_DOWN…
```

Qué pasa si falta uno:

| Sin esto | Pasa esto |
|---|---|
| `cbreak()` | `getch()` se bloquea hasta que pulsas Enter |
| `noecho()` | cada tecla que lees aparece sola en pantalla (eco) |
| `keypad(stdscr, TRUE)` | la flecha llega como tres teclas: `ESC`, `[`, `A` |

**Regla: los tres van juntos al empezar.** Si tu programa ignora las flechas, casi siempre es porque falta `keypad`.

## Las flechas son números

Con `keypad` activado, ncurses reconoce la secuencia que manda la terminal y la convierte en una constante especial:

| Constante | Número | Tecla |
|---|---|---|
| `KEY_DOWN` | 258 | flecha abajo |
| `KEY_UP` | 259 | flecha arriba |
| `KEY_LEFT` | 260 | flecha izquierda |
| `KEY_RIGHT` | 261 | flecha derecha |
| `KEY_BACKSPACE` | 263 | retroceso |
| `KEY_ENTER` | 343 | Enter del teclado numérico |

Todas valen más de 255, así que no se confunden con ninguna letra.

**Regla de oro: compara siempre con la constante, nunca con el número.** Escribe `tecla == KEY_UP`, jamás `tecla == 259`.

```c
int tecla = getch();
if (tecla == KEY_UP || tecla == 'k')   seleccion--;
if (tecla == KEY_DOWN || tecla == 'j') seleccion++;
```

Aceptar la letra y la flecha a la vez es el patrón de todo el curso.

## getch() devuelve int, no char

Las teclas normales también son números:

| Tecla | Número |
|---|---|
| `'\n'` (Enter por pipe) | 10 |
| `'\r'` (retorno de carro) | 13 |
| `'0'` … `'9'` | 48 … 57 |
| `'q'` | 113 |
| Ctrl-C | 3 |

**Guarda la tecla siempre en un `int`.** Si escribes `char c = getch();` los valores 256-511 se truncan y las flechas se convierten en basura: `KEY_UP` (259) pasaría a ser 3.

```c
int tecla = getch();          // bien
if (tecla == '\n') break;     // Enter

char t = getch();             // mal: pierde KEY_*
if (t == KEY_UP) …            // nunca se cumple
```

No hagas cast a `char` para comparar. `KEY_UP`, `KEY_ENTER` y `ERR` solo existen como `int`.

## Cada ventana lee con su propio getch

`getch()` es en realidad `wgetch(stdscr)`. Si trabajas con varias ventanas, cada una lee con la suya:

```c
WINDOW *v = newwin(5, 20, 1, 1);
keypad(v, TRUE);            // las flechas también en esta ventana
int tecla = wgetch(v);      // lee con la ventana v activa
wrefresh(v);
```

**`keypad` se activa por ventana:** `keypad(stdscr, TRUE)` no vale para `v`. Si una ventana no tiene su `keypad`, sus flechas llegan como `ESC`.

## Devolver una tecla: ungetch

`ungetch(tecla)` devuelve una tecla al buffer de entrada, para que la vuelvas a leer en la siguiente llamada:

```c
int tecla = getch();
if (tecla == 'q') ungetch(tecla);   // la deja otra vez en el buffer
int otra = getch();                 // vuelve a ser 'q'
```

Sirve para no consumir una tecla que todavía no sabes qué hacer con ella.

## Por qué las pruebas usan letras (y tu terminal, flechas)

Las pruebas envían la entrada por un **pipe**, no por una terminal. Con pipe, ncurses ve los bytes sueltos de la secuencia de la flecha: primero `ESC` (27), luego `[`, luego `A`. **Nunca llega `KEY_UP`.**

Por eso el código del curso acepta las dos formas:

```c
if (tecla == 'j' || tecla == KEY_DOWN) …   // letra en la prueba, flecha en tu terminal
```

- En tu terminal, con `keypad` activado, funcionan las flechas de verdad.
- En las pruebas solo llegan letras (`j`, `k`, `q`) y `'\n'` (10) cuando hay salto de línea.
- Enter en terminal real puede llegar como `KEY_ENTER`; por pipe llega como `'\n'`. Acepta las tres: `'\n'`, `'\r'` y `KEY_ENTER`.

## Errores típicos

- **Olvidar `keypad(stdscr, TRUE)`.** Las flechas llegan como tres teclas (`ESC`, `[`, `A`) y tu menú no responde. Arreglo: activa `keypad` en la misma ventana que vas a leer.
- **Comparar con `'w'` cuando el usuario pulsa la flecha arriba.** `getch()` devuelve `KEY_UP`, no `'w'`. Arreglo: `if (tecla == 'w' || tecla == KEY_UP)`.
- **Hacer `(char)getch()`.** `KEY_UP` (259) se trunca a 3 y la comparación falla. Arreglo: guarda la tecla en un `int` y compara con la constante.
- **Esperar que `getch()` devuelva `0` al final.** Devuelve `ERR`, nunca `0`. Arreglo: `while ((tecla = getch()) != ERR)`.
- **Escribir números mágicos** como `tecla == 259`. Funciona, pero nadie lo entiende. Arreglo: `KEY_UP`.

## Resumen en 5 puntos

- `cbreak()`, `noecho()` y `keypad(stdscr, TRUE)` van juntos: sin ellos esperas Enter, ves eco y las flechas llegan como `ESC`.
- `getch()` devuelve `int`: una letra (`'q'` = 113, `'\n'` = 10), una tecla especial (`KEY_UP` = 259) o `ERR`.
- Compara con la constante: `KEY_UP`, no `259`; `'\n'`, no un número mágico. Nunca hagas cast a `char`.
- Las ventanas leen con `wgetch(ventana)` y necesitan su propio `keypad(ventana, TRUE)`.
- `ungetch()` devuelve una tecla al buffer. En las pruebas la entrada va por pipe y solo llegan letras; en tu terminal funcionan las flechas, por eso el código acepta ambas.

## Qué vas a practicar

- **menu-de-inicio**: un menú navegable con `j`/`k` y flechas, con la selección sin salirse de los límites.
- **calculadora-de-teclas**: procesar una cadena de teclas y mantener una pantalla (`display`) al día con cada tecla.
