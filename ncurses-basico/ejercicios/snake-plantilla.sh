#!/usr/bin/env bash
set -euo pipefail

cat > snake.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ALTO 10
#define ANCHO 20

typedef struct { int y; int x; } Punto;

/* Estado que deja jugar() en el sitio para que el andamiaje dibuje el final:
   segmentos[0] es la cabeza y comida_idx apunta a la comida pendiente. */
static Punto segmentos[64];
static Punto comidas[3] = { {5, 8}, {2, 2}, {7, 15} };
static int comida_idx = 0;

/* Juega una partida determinista procesando cada carácter de teclas como un
   paso: 'w'/'a'/'s'/'d' (o flechas) giran, 'q' para y el resto se ignora. */
static void jugar(char *teclas, int *score, int *largo, int *vivo, int *hy, int *hx) {
    (void)teclas;
    (void)score;
    (void)largo;
    (void)vivo;
    (void)hy;
    (void)hx;
    // TODO 1: estado inicial: *score = 0, *largo = 3, *vivo = 1, *hy = 5, *hx = 5;
    //         segmentos[0] = {5, 5} (cabeza), segmentos[1] = {5, 4}, segmentos[2] = {5, 3};
    //         comida_idx = 0; dirección derecha (diry = 0, dirx = 1)
    // TODO 2: bucle por cada carácter de teclas:
    //         'q' termina el bucle; teclas desconocidas se ignoran (no mueven);
    //         'w'/KEY_UP, 'a'/KEY_LEFT, 's'/KEY_DOWN, 'd'/KEY_RIGHT cambian la
    //         dirección, pero NUNCA un giro de 180° (si va a la derecha, 'a' se
    //         ignora por completo). Ojo: la primera tecla de la partida fija la
    //         dirección inicial, aunque sea 'a'.
    // TODO 3: cada tecla válida da UN paso: ny = hy + diry, nx = hx + dirx.
    //         - pared: ny < 0 || ny >= ALTO || nx < 0 || nx >= ANCHO →
    //           *vivo = 0, la cabeza se queda en la posición del choque y terminas
    //         - auto-choque: si (ny, nx) coincide con segmentos[1..largo-1] →
    //           *vivo = 0, la cabeza se queda en la posición del choque y terminas
    // TODO 4: si la nueva cabeza está en comidas[comida_idx]: (*score)++ y
    //         comida_idx++; ese paso el animal crece ((*largo)++ y NO se descarta
    //         la cola). Si no comió, la cola se pierde al desplazar.
    // TODO 5: actualiza los segmentos: recorre desde *largo - 1 hasta 0 haciendo
    //         segmentos[s + 1] = segmentos[s], pon la cabeza nueva en
    //         segmentos[0] y actualiza *hy, *hx
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout el estado. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    char teclas[256] = "";
    if (fgets(teclas, sizeof teclas, stdin))
        teclas[strcspn(teclas, "\n")] = '\0';

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    resizeterm(12, 22);

    int score = 0, largo = 0, vivo = 0, hy = 0, hx = 0;
    jugar(teclas, &score, &largo, &vivo, &hy, &hx);

    for (int i = largo - 1; i >= 1; i--) {   /* cuerpo, de la cola a la nuca */
        int y = segmentos[i].y, x = segmentos[i].x;
        if (y >= 0 && y < ALTO && x >= 0 && x < ANCHO) mvaddch(y, x, 'o');
    }
    if (largo > 0) {                         /* cabeza encima del cuerpo */
        int y = segmentos[0].y, x = segmentos[0].x;
        if (y >= 0 && y < ALTO && x >= 0 && x < ANCHO) mvaddch(y, x, '@');
    }
    if (comida_idx < 3) {
        int y = comidas[comida_idx].y, x = comidas[comida_idx].x;
        if (y >= 0 && y < ALTO && x >= 0 && x < ANCHO) mvaddch(y, x, '*');
    }
    refresh();

    endwin();
    delscreen(pantalla);

    printf("score=%d largo=%d estado=%s cabeza=%d,%d\n",
           score, largo, vivo ? "vivo" : "muerto", hy, hx);
    return 0;
}
C

gcc snake.c -lncurses -o snake
./snake 2>/dev/null
