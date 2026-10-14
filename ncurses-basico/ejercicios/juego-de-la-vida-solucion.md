```bash
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
    for (int f = 0; f < filas; f++) {
        for (int c = 0; c < columnas; c++) {
            int vivos = 0;
            for (int df = -1; df <= 1; df++) {
                for (int dc = -1; dc <= 1; dc++) {
                    if (df == 0 && dc == 0) continue;
                    int vf = f + df, vc = c + dc;
                    if (vf < 0 || vf >= filas || vc < 0 || vc >= columnas) continue;
                    if (g[vf][vc] == '#') vivos++;
                }
            }
            if (g[f][c] == '#')
                destino[f][c] = (vivos == 2 || vivos == 3) ? '#' : '.';
            else
                destino[f][c] = (vivos == 3) ? '#' : '.';
        }
    }
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
```

El truco clave es la **matriz destino**: `evolucionar` lee siempre de `g` (el estado actual, con el que se cuentan los vecinos de todas las celdas) y escribe solo en `destino`; cuando termina, `memcpy(g, destino, sizeof g)` trae la generación nueva. Si mutaras `g` mientras cuentas, las celdas ya procesadas cambiarían los vecinos de las que faltan y la simulación sería basura.

Las celdas fuera de la matriz cuentan como muertas: por eso el bucle de vecinos comprueba `vf < 0 || vf >= filas || vc < 0 || vc >= columnas` y las salta. Sin esa comprobación leerías `g[-1][-1]` y el resultado dependiera de la memoria que toque. Y en pantalla se dibuja `O` en lugar de `#` (más legible en una terminal): el modelo y el dibujo son piezas distintas, como en el capítulo 9.
