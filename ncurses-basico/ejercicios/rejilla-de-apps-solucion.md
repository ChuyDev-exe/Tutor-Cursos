```bash
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
    int filas_nec = (n + COLS_GRID - 1) / COLS_GRID;
    int fila_base = (LINES - filas_nec) / 2;
    int sel = 0;
    int fila = 0, col = 0;
    for (;;) {
        werase(stdscr);
        for (int i = 0; i < n; i++) {
            int f = fila_base + i / COLS_GRID;
            int x = 2 + (i % COLS_GRID) * ANCHO_CELDA;
            if (i == sel) attron(A_REVERSE);
            mvprintw(f, x, "%s", apps[i]);
            if (i == sel) attroff(A_REVERSE);
        }
        refresh();
        int tecla = getch();
        if (tecla == '\n' || tecla == 'q' || tecla == KEY_ENTER || tecla == ERR) break;
        if ((tecla == 'l' || tecla == KEY_RIGHT) && col < COLS_GRID - 1) col++;
        else if ((tecla == 'h' || tecla == KEY_LEFT) && col > 0) col--;
        else if ((tecla == 'j' || tecla == KEY_DOWN) && fila < filas_nec - 1) fila++;
        else if ((tecla == 'k' || tecla == KEY_UP) && fila > 0) fila--;
        sel = fila * COLS_GRID + col;
        if (sel >= n) { sel = n - 1; fila = sel / COLS_GRID; col = sel % COLS_GRID; }
    }
    return sel;
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
```

La rejilla se traduce a números: el índice `i` es `fila * COLS_GRID + col`, y al dibujar `i / COLS_GRID` da la fila e `i % COLS_GRID` la columna. Los límites se comprueban **antes** de sumar (`col < COLS_GRID - 1`), y el índice se vuelve a calcular en cada vuelta para no salirse del array `apps`. Al cambiar la selección se borra todo con `werase(stdscr)` y se redibuja: si solo repintas la celda vieja y la nueva, se acumulan rastros.
