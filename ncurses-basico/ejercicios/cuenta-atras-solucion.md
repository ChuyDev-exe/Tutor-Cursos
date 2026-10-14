```bash
#!/usr/bin/env bash
set -euo pipefail

cat > cuenta_atras.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

/* Temporizador: cuenta hacia atrás y vacía una barra. */
void cuenta_atras(int segundos) {
    if (segundos <= 0) {
        mvprintw(1, 1, "¡Tiempo!");
        refresh();
        return;
    }
    timeout(1);
    for (int restante = segundos; restante >= 0; restante--) {
        mvprintw(1, 1, "quedan %2d s", restante);
        mvhline(3, 1, ' ', COLS - 1);
        for (int i = 0; i < restante && 1 + i < COLS; i++)
            mvaddch(3, 1 + i, '#');
        refresh();
        getch();   /* tick: una tecla o ERR */
    }
    mvhline(3, 1, ' ', COLS - 1);
    mvhline(1, 1, ' ', 12);
    mvprintw(1, 1, "¡Tiempo!");
    refresh();
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
```

`mvhline(1, 1, ' ', 12)` borra el texto `quedan  0 s` **antes** de escribir `¡Tiempo!`. Si no lo haces, del mensaje viejo quedan colgando caracteres (`¡Tiempo!0 s`), porque `¡Tiempo!` es más corto. Es el mismo principio que en toda animación: borra lo viejo antes de dibujar lo nuevo. La barra se vacía igual: se repinta con espacios y solo después se escribe el rótulo final.
