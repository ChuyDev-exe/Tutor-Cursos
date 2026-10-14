#!/usr/bin/env bash
set -euo pipefail

cat > barra_de_progreso.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

#define CELDAS 20

/* Instala 20 actualizaciones. Avanza 1 celda por paso. */
static void instalar(void) {
    // TODO 1: timeout(1) sobre stdscr: getch() espera como mucho 1 ms y devuelve ERR si no hay tecla
    // TODO 2: bucle de CELDAS pasos (paso = 0, 1, 2, ...). En cada paso:
    //             dibuja '#' en la celda (2, 2 + paso) con mvaddch
    //             refresh()
    //             getch()  — la tecla o ERR solo hacen de "tick", no cambian nada más
    // TODO 3: al terminar los CELDAS pasos, escribe "100%" en la fila 0, columna 0 y refresca
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en ella. */
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
    resizeterm(5, 30);

    instalar();

    char fila[31];
    memset(fila, ' ', 30);
    fila[30] = '\0';
    mvinnstr(2, 0, fila, 30);

    char barra[CELDAS + 1];
    memcpy(barra, fila + 2, CELDAS);
    barra[CELDAS] = '\0';
    int n = CELDAS;
    while (n > 0 && barra[n - 1] == ' ') barra[--n] = '\0';

    int pasos = 0;
    for (int i = 0; i < CELDAS; i++)
        if (barra[i] == '#') pasos++;

    endwin();
    delscreen(pantalla);

    printf("barra=%s\npaso_final=%d\n", barra, pasos);
    return 0;
}
C

gcc barra_de_progreso.c -lncurses -o barra_de_progreso
./barra_de_progreso 2>/dev/null
