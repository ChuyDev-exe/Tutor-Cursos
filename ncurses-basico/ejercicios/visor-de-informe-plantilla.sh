#!/usr/bin/env bash
set -euo pipefail

cat > visor_de_informe.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PAD_ALTO 30
#define VIS_ALTO 5

/* Visor de un informe de 30 líneas guardado en un pad. El pad ya tiene
   las líneas escritas. Rellena el viewport y lee teclas de scroll.
   Al terminar, *top es la fila del pad que se ve en la primera fila
   de pantalla. */
static void ver_informe(WINDOW *pad, int *top) {
    (void)pad;
    *top = 0;
    // TODO 1: pinta el viewport la primera vez con
    //         prefresh(pad, *top, 0, 0, 0, 4, 14)
    //         (5 filas de pantalla: 0..4, 15 columnas: 0..14)
    // TODO 2: bucle con getch(): 'j' o KEY_DOWN sube *top (máximo PAD_ALTO - VIS_ALTO),
    //         'k' o KEY_UP baja (mínimo 0), 'q' o ERR terminan el bucle
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

    WINDOW *pad = newpad(PAD_ALTO, 15);
    if (!pad) { printf("No se pudo crear el pad\n"); return 1; }
    for (int f = 0; f < PAD_ALTO; f++)
        mvwprintw(pad, f, 0, "linea %02d", f + 1);

    int top = 0;
    ver_informe(pad, &top);

    char v1[16] = {0};
    char v5[16] = {0};
    mvwinnstr(pad, top + 0, 0, v1, 14);
    mvwinnstr(pad, top + VIS_ALTO - 1, 0, v5, 14);
    recortar_dcha(v1);
    recortar_dcha(v5);

    delwin(pad);
    endwin();
    delscreen(pantalla);

    printf("top=%d\nv1=%s\nv5=%s\n", top, v1, v5);
    return 0;
}
C

gcc visor_de_informe.c -lncurses -o visor_de_informe
./visor_de_informe 2>/dev/null
