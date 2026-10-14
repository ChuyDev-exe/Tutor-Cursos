```bash
#!/usr/bin/env bash
set -euo pipefail

cat > menu_inicio.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Dibuja las n opciones en las filas 1..n de stdscr y deja que el usuario
   elija con j/k (o flechas). Devuelve el índice de la opción elegida. */
int elegir_opcion(const char **opciones, int n) {
    int sel = 0;
    while (1) {
        erase();
        for (int i = 0; i < n; i++) {
            if (i == sel) {
                attron(A_REVERSE);
                mvprintw(i + 1, 2, "> %s", opciones[i]);
                attroff(A_REVERSE);
            } else {
                mvprintw(i + 1, 2, "  %s", opciones[i]);
            }
        }
        refresh();

        int tecla = getch();
        if (tecla == ERR) break;
        if (tecla == 'k' || tecla == KEY_UP) {
            if (sel > 0) sel--;
        } else if (tecla == 'j' || tecla == KEY_DOWN) {
            if (sel < n - 1) sel++;
        } else if (tecla == '\n' || tecla == '\r' || tecla == KEY_ENTER || tecla == 'q') {
            break;
        }
    }
    return sel;
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en ella. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

static const char *OPCIONES[] = {"Procesos", "Discos", "Red", "Salir"};

int main(void) {
    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);

    int seleccion = elegir_opcion(OPCIONES, 4);
    if (seleccion < 0 || seleccion >= 4) seleccion = 0;

    endwin();
    delscreen(pantalla);

    printf("seleccion=%d\ntitulo=%s\n", seleccion, OPCIONES[seleccion]);
    return 0;
}
C

gcc menu_inicio.c -lncurses -o menu_inicio
./menu_inicio 2>/dev/null
```

La clave es **repintar entero en cada vuelta** con `erase()`: si no, la marca `"> "` y el `A_REVERSE` de la fila anterior quedan clavados en pantalla. La otra clave es guardar la tecla en un `int`: así `'j'` (106) y `KEY_DOWN` (258) pueden entrar en el mismo `if` sin perder ninguna de las dos.
