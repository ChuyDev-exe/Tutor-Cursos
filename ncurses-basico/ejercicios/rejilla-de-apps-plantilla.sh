#!/usr/bin/env bash
set -euo pipefail

cat > rejilla_de_apps.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

#define COLS_GRID 3
#define ANCHO_CELDA 14

/* Lanzador de apps en rejilla. Devuelve el índice elegido (0..n-1). */
int lanzador(const char **apps, int n) {
    // TODO 1: filas necesarias = (n + COLS_GRID - 1) / COLS_GRID;  seleccionada = 0
    // TODO 2: fila_base = (LINES - filas_necesarias) / 2   /* rejilla centrada en vertical */
    // TODO 3: dibuja la rejilla en un bucle for (i = 0; i < n; i++):
    //             fila = fila_base + i / COLS_GRID
    //             col  = 2 + (i % COLS_GRID) * ANCHO_CELDA
    //             la app seleccionada se dibuja con attron(A_REVERSE) ... attroff(A_REVERSE)
    //             la app i se dibuja en (fila, col) con mvprintw(fila, col, "%s", apps[i])
    //             y al final refresh()
    // TODO 4: bucle de teclas: 'h'/KEY_LEFT, 'l'/KEY_RIGHT cambian la columna; 'k'/KEY_UP,
    //             'j'/KEY_DOWN cambian la fila. Sin salirse: fila en 0..filas_necesarias-1,
    //             columna en 0..COLS_GRID-1, y el índice (fila * COLS_GRID + col) < n
    // TODO 5: '\n', 'q', KEY_ENTER o ERR terminan el bucle (devuelve la seleccionada)
    // TODO 6: al cambiar la selección vuelve a empezar: werase(stdscr) y redibuja todo
    return 0;
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en ella. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    static const char *apps[] = {
        "terminal", "editor", "navegador", "archivos", "musica", "ajustes"
    };
    int n = (int)(sizeof apps / sizeof apps[0]);

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    resizeterm(12, 44);

    int indice = lanzador(apps, n);

    endwin();
    delscreen(pantalla);

    printf("elegida=%s\nfila=%d\ncol=%d\n",
           apps[indice], indice / COLS_GRID, indice % COLS_GRID);
    return 0;
}
C

gcc rejilla_de_apps.c -lncurses -o rejilla_de_apps
./rejilla_de_apps 2>/dev/null
