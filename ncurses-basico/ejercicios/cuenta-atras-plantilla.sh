#!/usr/bin/env bash
set -euo pipefail

cat > cuenta_atras.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

/* Temporizador: cuenta hacia atrás y vacía una barra. */
void cuenta_atras(int segundos) {
    // TODO 1: si segundos <= 0, escribe "¡Tiempo!" en la fila 1, columna 1, refresca y termina
    // TODO 2: timeout(1): getch() espera como mucho 1 ms y devuelve ERR si no hay tecla
    // TODO 3: bucle descendente restante = segundos, segundos-1, ..., 0. En cada vuelta:
    //             mvprintw(1, 1, "quedan %2d s", restante)
    //             borra la barra vieja con mvhline(3, 1, ' ', COLS - 1) y dibuja
    //             'restante' celdas '#' en la fila 3 desde la columna 1
    //             (no te salgas de la pantalla: no pintes si 1 + i >= COLS)
    //             refresh(); getch()  — la tecla o ERR solo hacen de "tick"
    // TODO 4: al terminar borra lo viejo y escribe el rótulo final:
    //             mvhline(3, 1, ' ', COLS - 1)   /* limpia la barra */
    //             mvhline(1, 1, ' ', 12)         /* limpia "quedan N s" */
    //             mvprintw(1, 1, "¡Tiempo!"); refresh();
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en ella. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    /* La primera línea de la entrada son los segundos; el resto es para getch(). */
    char linea[32] = "";
    if (!fgets(linea, sizeof linea, stdin)) linea[0] = '\0';
    int segundos = 0;
    sscanf(linea, "%d", &segundos);

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    resizeterm(6, 30);

    cuenta_atras(segundos);

    char mensaje[64];
    memset(mensaje, 0, sizeof mensaje);
    mvinnstr(1, 1, mensaje, 10);
    mensaje[63] = '\0';
    int m = (int)strlen(mensaje);
    while (m > 0 && mensaje[m - 1] == ' ') mensaje[--m] = '\0';

    char barra[64];
    memset(barra, 0, sizeof barra);
    mvinnstr(3, 1, barra, 29);
    barra[63] = '\0';
    int b = (int)strlen(barra);
    while (b > 0 && barra[b - 1] == ' ') barra[--b] = '\0';

    int restante = 0;
    for (int i = 0; i < b; i++)
        if (barra[i] == '#') restante++;

    endwin();
    delscreen(pantalla);

    printf("mensaje=%s\nbarra=%s\nrestante=%d\n", mensaje, barra, restante);
    return 0;
}
C

gcc cuenta_atras.c -lncurses -o cuenta_atras
./cuenta_atras 2>/dev/null
