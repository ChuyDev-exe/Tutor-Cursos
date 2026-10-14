# 3. Colores y atributos

## Objetivo

Al terminar este capítulo sabrás encender y apagar colores por celda, leer el color de una celda dibujada y combinar color con negrita u otros atributos.

## Mapa del capítulo

- `has_colors()` y `start_color()`: qué llamar antes de pintar.
- `init_pair`: la paleta de parejas tinta/fondo.
- `attron` / `attroff`: el patrón que se repite en todos los programas.
- Cambiar una pareja en caliente: el truco del parpadeo.
- Atributos sin color: `A_BOLD`, `A_REVERSE`, `A_DIM`, `A_UNDERLINE`.
- Leer el color de una celda: `PAIR_NUMBER` y `A_COLOR`.

## Antes de pintar: has_colors y start_color

No todas las terminales pueden mostrar color. Compruébalo primero:

```c
if (has_colors()) {
    start_color();          // activa el sistema de color
    init_pair(1, COLOR_GREEN, COLOR_BLACK);
}
```

**Regla: `start_color()` se llama una sola vez, al arrancar, después de abrir la pantalla.**

Colores disponibles: `COLOR_BLACK`, `COLOR_RED`, `COLOR_GREEN`, `COLOR_YELLOW`, `COLOR_BLUE`, `COLOR_MAGENTA`, `COLOR_CYAN`, `COLOR_WHITE`.

## init_pair: la paleta de parejas

Una pareja es una combinación tinta + fondo con un número. `init_pair(numero, tinta, fondo)` la define:

```c
init_pair(1, COLOR_GREEN, COLOR_BLACK);   // texto verde sobre negro
init_pair(2, COLOR_YELLOW, COLOR_BLACK);  // texto amarillo sobre negro
init_pair(3, COLOR_RED, COLOR_BLACK);     // texto rojo sobre negro
```

**Los números válidos van de 1 a `COLOR_PAIRS - 1`. La pareja 0 está reservada para el texto normal: no la uses.**

## Cómo se aplica un color

`COLOR_PAIR(n)` no pinta nada sola: es una máscara que se enciende y se apaga como un interruptor.

```c
attron(COLOR_PAIR(1));        // enciende el color
mvprintw(3, 5, "OK");         // se escribe con el color puesto
attroff(COLOR_PAIR(1));       // apágalo SIEMPRE después
```

También puedes combinarlo con negrita en la misma máscara:

```c
attron(A_BOLD | COLOR_PAIR(3));   // rojo y negrita a la vez
printw("FALLO");
attroff(A_BOLD | COLOR_PAIR(3));
```

**Regla de oro: `attron` antes de escribir, `attroff` después. Si olvidas el `attroff`, el color se cuela en todo lo que se escriba después.**

## Cambiar una pareja en caliente

Las celdas no guardan el color «verde»: guardan el número de pareja. Si vuelves a llamar a `init_pair` con ese número, **todas las celdas que lo usaban cambian de golpe**. Es el truco de los gestores para hacer parpadear una alerta sin repintar pantalla a pantalla:

```c
init_pair(3, COLOR_RED, COLOR_BLACK);
// … más tarde, sin tocar las celdas:
init_pair(3, COLOR_BLACK, COLOR_RED);   // toda la alerta parpadea
```

## Atributos sin color

Si la terminal no tiene color todavía puedes dar énfasis:

| Atributo | Efecto |
|---|---|
| `A_BOLD` | negrita |
| `A_REVERSE` | colores invertidos (fondo y tinta se intercambian) |
| `A_DIM` | texto apagado |
| `A_UNDERLINE` | subrayado |

Se usan igual: `attron(A_REVERSE)` … `attroff(A_REVERSE)`.

## Leer el color de una celda

Una celda leída con `mvinch` es un `chtype`: carácter + atributos en un solo entero. `A_COLOR` es la máscara que aísla los bits de color:

```c
chtype celda = mvinch(3, 20);
int pareja = PAIR_NUMBER(celda & A_COLOR);   // 0, 1, 2, 3…
```

**Regla: `PAIR_NUMBER(celda & A_COLOR)` te devuelve el número de pareja; 0 significa «sin color».** Así comprueba el andamiaje de los ejercicios lo que pintaste.

## Errores típicos

- **Olvidar `start_color()`**: `init_pair` no hace nada y todo se ve sin color. Llama a `start_color()` una vez, al arrancar.
- **Usar la pareja 0**: está reservada para el texto normal; define las tuyas desde la 1.
- **Olvidar `attroff`**: el resto de la pantalla se pinta del último color. Apágalo justo después de escribir.
- **Esperar colores en una terminal monocromo**: `has_colors()` devuelve falso. Compruébalo y usa atributos como `A_BOLD` en su lugar.
- **Comparar colores con el color literal**: las celdas guardan números de pareja, no «verde». Usa `PAIR_NUMBER`.

## Resumen en 5 puntos

- `has_colors()` + `start_color()` una vez al arrancar.
- `init_pair(n, tinta, fondo)` define la pareja n (de 1 en adelante).
- `attron(COLOR_PAIR(n))` antes de escribir y `attroff` después.
- Cambiar `init_pair` en caliente cambia todas las celdas que usan esa pareja.
- `PAIR_NUMBER(celda & A_COLOR)` lee el color de una celda.

## Qué vas a practicar

- `barra-de-estados`: un panel de monitoreo con semáforo verde/amarillo/rojo por servicio.
- `termometro-de-uso`: una barra de 20 celdas que cambia de color según el porcentaje.
