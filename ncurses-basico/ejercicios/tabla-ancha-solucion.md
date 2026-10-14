```bash
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
    *izq = 0;
    prefresh(pad, 0, *izq, 0, 0, 6, VIS_CELDAS - 1);
    int tecla;
    while ((tecla = getch()) != 'q' && tecla != ERR) {
        if ((tecla == 'l' || tecla == KEY_RIGHT) && *izq < PAD_ANCHO - 12) *izq += ANCHO_CELDA;
        if ((tecla == 'h' || tecla == KEY_LEFT) && *izq > 0) *izq -= ANCHO_CELDA;
        prefresh(pad, 0, *izq, 0, 0, 6, VIS_CELDAS - 1);
    }
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
```

El desplazamiento horizontal usa el mismo truco que el vertical: mover `pmincol` y volver a llamar a `prefresh`. Cada celda ocupa 4 columnas, así que cada tecla `l`/`h` salta `izq += 4` / `izq -= 4`. Los límites son 0 y `48 - 12 = 36`; al llegar al límite derecho solo caben tres celdas del pad (`J0`, `K0`, `L0`) y el resto se leen vacías.

La lectura final no va a la pantalla sino al pad con `mvwinnstr(pad, 0, col, …)`: la fila visible `i` del pad está en la columna `izq + i * 4`. Las celdas con columna mayor o igual que 48 no existen y quedan como cadena vacía.
