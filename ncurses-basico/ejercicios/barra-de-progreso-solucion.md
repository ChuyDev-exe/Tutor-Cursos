```bash
#!/usr/bin/env bash
set -euo pipefail

cat > barra_de_progreso.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

#define CELDAS 20

/* Instala 20 actualizaciones. Avanza 1 celda por paso. */
static void instalar(void) {
    timeout(1);
    for (int paso = 0; paso < CELDAS; paso++) {
        mvaddch(2, 2 + paso, '#');
        refresh();
        getch();   /* tick: una tecla o ERR avanzan el paso */
    }
    mvprintw(0, 0, "100%");
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
```

`timeout(1)` convierte a `getch()` en un reloj: espera como mucho 1 ms y devuelve `ERR` si no hay tecla. El bucle avanza **un paso por tick**, venga o no venga tecla: la barra se llena igual con la entrada vacía que con 20 teclas basura. Al terminar, `mvprintw(0, 0, "100%")` pone el rótulo solo después del último `#`, sin arrastrar texto viejo.
