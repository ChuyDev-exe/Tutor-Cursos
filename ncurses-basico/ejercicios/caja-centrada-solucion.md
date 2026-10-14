```bash
#!/usr/bin/env bash
set -euo pipefail

cat > caja_centrada.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

#define ALTO 5

/* Diálogo modal centrado con el título en el borde superior. */
void caja_modal(const char *titulo, const char *mensaje) {
    werase(stdscr);
    refresh();
    int ancho = (int)strlen(titulo);
    if ((int)strlen(mensaje) > ancho) ancho = (int)strlen(mensaje);
    ancho += 6;
    if (ancho < 10) ancho = 10;
    int y = (LINES - ALTO) / 2;
    int x = (COLS - ancho) / 2;
    WINDOW *v = newwin(ALTO, ancho, y, x);
    box(v, 0, 0);
    mvwprintw(v, 0, 2, titulo);
    mvwprintw(v, 2, 2, mensaje);
    wrefresh(v);
    getch();
    delwin(v);
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en ella.
   La ventana de newwin no se guarda en stdscr: se lee de curscr, la pantalla física. */
static char celda_ascii(chtype c) {
    if (c & A_ALTCHARSET) {
        chtype a = c & A_CHARTEXT;
        if (a == (ACS_ULCORNER & A_CHARTEXT)) return '+';
        if (a == (ACS_URCORNER & A_CHARTEXT)) return '+';
        if (a == (ACS_LLCORNER & A_CHARTEXT)) return '+';
        if (a == (ACS_LRCORNER & A_CHARTEXT)) return '+';
        if (a == (ACS_HLINE & A_CHARTEXT)) return '-';
        if (a == (ACS_VLINE & A_CHARTEXT)) return '|';
        return '?';
    }
    return (char)(c & A_CHARTEXT);
}

static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    int filas = 10, cols = 30;
    char titulo[20] = "Hola", mensaje[20] = "Adios";
    scanf("%d %d %19s %19s", &filas, &cols, titulo, mensaje);

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    resizeterm(filas, cols);
    werase(stdscr);
    refresh();

    caja_modal(titulo, mensaje);

    for (int f = 0; f < filas; f++) {
        char linea[257];
        int n = 0;
        for (int c = 0; c < cols && c < 256; c++)
            linea[n++] = celda_ascii(mvwinch(curscr, f, c));
        linea[n] = '\0';
        while (n > 0 && linea[n - 1] == ' ') linea[--n] = '\0';
        printf("%s\n", linea);
    }
    endwin();
    delscreen(pantalla);
    return 0;
}
C

gcc caja_centrada.c -lncurses -o caja_centrada
./caja_centrada 2>/dev/null
```

La fórmula del centrado es `(LINES - alto) / 2` y `(COLS - ancho) / 2`: resto el tamaño de la caja al de la pantalla y divido entre 2. `max` no viene de serie para enteros, así que se hace con un `if` o con el operador ternario. El título se escribe en la fila 0 de la ventana, que **es** el borde superior: `mvwprintw` pisa solo esas celdas y el borde sigue viéndose a los lados.
