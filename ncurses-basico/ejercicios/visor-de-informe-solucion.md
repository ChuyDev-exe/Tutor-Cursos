```bash
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
    *top = 0;
    prefresh(pad, *top, 0, 0, 0, 4, 14);
    int tecla;
    while ((tecla = getch()) != 'q' && tecla != ERR) {
        if ((tecla == 'j' || tecla == KEY_DOWN) && *top < PAD_ALTO - VIS_ALTO) (*top)++;
        if ((tecla == 'k' || tecla == KEY_UP) && *top > 0) (*top)--;
        prefresh(pad, *top, 0, 0, 0, 4, 14);
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
```

El truco clave es `prefresh(pad, pminrow, pmincol, sminrow, smincol, smaxrow, smaxcol)`: los dos primeros números dicen **qué parte del pad** se muestra y los cuatro últimos **dónde cae en pantalla**. `prefresh(pad, top, 0, 0, 0, 4, 14)` pinta el pad desde la fila `top` en las filas 0..4 y columnas 0..14 de la pantalla. Desplazar es cambiar `top` y volver a llamar a `prefresh`; nunca con `wrefresh`, que no sirve para pads.

El clamp es obligatorio: con 30 filas de pad y un viewport de 5, `top` va de 0 a 25 (`30 - 5`). Si `top` se pasa, `prefresh` intenta mostrar filas que no existen y el resultado es una pantalla incompleta.
