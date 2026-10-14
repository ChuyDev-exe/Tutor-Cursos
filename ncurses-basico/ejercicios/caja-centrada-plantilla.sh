#!/usr/bin/env bash
set -euo pipefail

cat > caja_centrada.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

#define ALTO 5

/* Diálogo modal centrado con el título en el borde superior. */
void caja_modal(const char *titulo, const char *mensaje) {
    // TODO 1: werase(stdscr); refresh();  — deja la pantalla en blanco
    // TODO 2: ancho = max(strlen(titulo), strlen(mensaje)) + 6, sin bajar de 10
    // TODO 3: centra la ventana: y = (LINES - ALTO) / 2;  x = (COLS - ancho) / 2
    // TODO 4: WINDOW *v = newwin(ALTO, ancho, y, x); box(v, 0, 0);
    // TODO 5: mvwprintw(v, 0, 2, titulo);   /* título en el borde superior */
    // TODO 6: mvwprintw(v, 2, 2, mensaje);  /* mensaje dentro de la caja */
    // TODO 7: wrefresh(v); getch(); delwin(v);  /* una tecla para cerrar */
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
