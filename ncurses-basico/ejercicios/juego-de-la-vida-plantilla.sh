#!/usr/bin/env bash
set -euo pipefail

cat > inicial.txt <<'EOF'
............
....#.......
...###......
............
....#.#.....
............
EOF

cat > juego_de_la_vida.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FILAS 6
#define COLUMNAS 12

/* Calcula UNA generación: lee g y escribe en destino (bordes muertos).
   Vivo = '#', muerto = '.'. No toques g: cuenta sobre el estado actual. */
static void evolucionar(char g[FILAS][COLUMNAS + 1], char destino[FILAS][COLUMNAS + 1],
                        int filas, int columnas) {
    (void)g;
    (void)destino;
    (void)filas;
    (void)columnas;
    // TODO 1: para cada celda (f, c) de la matriz:
    //         cuenta sus 8 vecinas: los bucles df de -1 a 1 y dc de -1 a 1,
    //         saltando la celda central (df == 0 && dc == 0) y las que caen
    //         fuera de la matriz (vf < 0 || vf >= filas || vc < 0 || vc >= columnas:
    //         los bordes cuentan como muertos, nunca leas fuera)
    // TODO 2: destino[f][c] = '#' solo si:
    //         - estaba viva (g[f][c] == '#') y tiene 2 o 3 vecinos vivos, o
    //         - estaba muerta y tiene exactamente 3 vecinos vivos.
    //         En cualquier otro caso, destino[f][c] = '.'.
    //         Ojo: escribe SIEMPRE en destino, nunca en g.
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* En pantalla se dibuja 'O' (vivo) y '.' (muerto), más legible que '#'. */
static void dibujar(char g[FILAS][COLUMNAS + 1]) {
    for (int f = 0; f < FILAS; f++)
        for (int c = 0; c < COLUMNAS; c++)
            mvaddch(f, c, g[f][c] == '#' ? 'O' : '.');
    refresh();
}

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout el estado. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    char g[FILAS][COLUMNAS + 1];
    char destino[FILAS][COLUMNAS + 1];
    memset(g, '.', sizeof g);
    int leidas = 0;
    FILE *f = fopen("inicial.txt", "r");
    if (f) {
        char buf[64];
        while (leidas < FILAS && fgets(buf, sizeof buf, f)) {
            buf[strcspn(buf, "\n")] = '\0';
            for (int c = 0; c < COLUMNAS; c++)
                g[leidas][c] = buf[c] ? buf[c] : '.';
            g[leidas][COLUMNAS] = '\0';
            leidas++;
        }
        fclose(f);
    }

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    resizeterm(6, 14);

    dibujar(g);
    int generaciones = 0;
    int tecla;
    while ((tecla = getch()) != 'q' && tecla != ERR) {
        if (tecla == 'n' || tecla == '\n') {
            evolucionar(g, destino, FILAS, COLUMNAS);
            memcpy(g, destino, sizeof g);
            generaciones++;
            dibujar(g);
        }
    }

    char fila_txt[FILAS][16];
    for (int f2 = 0; f2 < FILAS; f2++) {
        char buf[16] = {0};
        mvinnstr(f2, 0, buf, COLUMNAS);
        buf[COLUMNAS] = '\0';
        snprintf(fila_txt[f2], sizeof fila_txt[f2], "%s", buf);
    }

    endwin();
    delscreen(pantalla);

    printf("generaciones=%d\n", generaciones);
    for (int f2 = 0; f2 < FILAS; f2++) printf("fila=%s\n", fila_txt[f2]);
    return 0;
}
C

gcc juego_de_la_vida.c -lncurses -o juego_de_la_vida
./juego_de_la_vida 2>/dev/null
