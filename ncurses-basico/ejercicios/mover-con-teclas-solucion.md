```bash
#!/usr/bin/env bash
set -euo pipefail

cat > mover.c <<'C'
#include <ncurses.h>
#include <stdio.h>

#define ALTO 10
#define ANCHO 20

/* Lee teclas hasta 'q' o hasta que no haya más (ERR) y mueve la @.
   Al terminar, *y y *x tienen la posición final. */
static void jugar(int *y, int *x) {
    mvaddch(*y, *x, '@');
    refresh();
    int tecla;
    while ((tecla = getch()) != 'q' && tecla != ERR) {
        mvaddch(*y, *x, ' ');
        if (tecla == 'w' && *y > 0) (*y)--;
        if (tecla == 's' && *y < ALTO - 1) (*y)++;
        if (tecla == 'a' && *x > 0) (*x)--;
        if (tecla == 'd' && *x < ANCHO - 1) (*x)++;
        mvaddch(*y, *x, '@');
        refresh();
    }
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

    int y = 0, x = 0;
    jugar(&y, &x);

    char celda = (char)(mvinch(y, x) & A_CHARTEXT);
    int arrobas = 0;
    for (int f = 0; f < ALTO; f++)
        for (int c = 0; c < ANCHO; c++)
            if ((mvinch(f, c) & A_CHARTEXT) == '@') arrobas++;
    endwin();
    delscreen(pantalla);

    printf("y=%d x=%d\ncelda=%c\narrobas=%d\n", y, x, celda, arrobas);
    return 0;
}
C

gcc mover.c -lncurses -o mover
./mover 2>/dev/null
```

`getch()` devuelve una tecla cada vez y `ERR` cuando ya no hay más entrada. Antes de mover, la celda vieja se borra con un espacio; si no, quedaría un rastro de `@`. Las comprobaciones `*y > 0`, `*y < ALTO - 1`… impiden salir del área.
