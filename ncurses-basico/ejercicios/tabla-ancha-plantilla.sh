#!/usr/bin/env bash
set -euo pipefail

cat > tabla_ancha.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PAD_FILAS 10
#define PAD_ANCHO 48
#define VIS_CELDAS 12
#define ANCHO_CELDA 4

/* Visor de una tabla de 12 columnas de ancho (celdas "A0 ", "B3 "…).
   El pad ya tiene la tabla escrita. Desplaza la vista horizontalmente.
   Al terminar, *izq es la columna del pad que se ve en la columna 0
   de pantalla. */
static void ver_tabla(WINDOW *pad, int *izq) {
    (void)pad;
    *izq = 0;
    // TODO 1: pinta el viewport la primera vez con
    //         prefresh(pad, 0, *izq, 0, 0, 6, 11)
    //         (7 filas de pantalla: 0..6, 12 columnas: 0..11)
    // TODO 2: bucle con getch(): 'l' o KEY_RIGHT suma 4 a *izq (máximo 36),
    //         'h' o KEY_LEFT resta 4 (mínimo 0), 'q' o ERR terminan el bucle
    // TODO 3: tras cada tecla vuelve a llamar a prefresh; wrefresh no sirve en pads
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* Quita los espacios que quedan a la derecha de una celda leída del pad. */
static void recortar_dcha(char *s) {
    size_t n = strlen(s);
    while (n > 0 && s[n - 1] == ' ') s[--n] = '\0';
}

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout el estado. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    resizeterm(8, 20);

    WINDOW *pad = newpad(PAD_FILAS, PAD_ANCHO);
    if (!pad) { printf("No se pudo crear el pad\n"); return 1; }
    for (int f = 0; f < PAD_FILAS; f++)
        for (int c = 0; c < VIS_CELDAS; c++)
            mvwprintw(pad, f, c * ANCHO_CELDA, "%c%d ", 'A' + c, f);

    int izq = 0;
    ver_tabla(pad, &izq);

    /* Lista las 12 celdas de la fila 0 del pad desde la columna izq.
       Las que caen fuera del pad (col >= 48) se leen vacías. */
    char cab[128] = "";
    for (int i = 0; i < VIS_CELDAS; i++) {
        char celda[8] = {0};
        int col = izq + i * ANCHO_CELDA;
        if (col < PAD_ANCHO) mvwinnstr(pad, 0, col, celda, ANCHO_CELDA);
        recortar_dcha(celda);
        if (i > 0) strcat(cab, "|");
        strcat(cab, celda);
    }

    delwin(pad);
    endwin();
    delscreen(pantalla);

    printf("izq=%d\ncab=%s\n", izq, cab);
    return 0;
}
C

gcc tabla_ancha.c -lncurses -o tabla_ancha
./tabla_ancha 2>/dev/null
