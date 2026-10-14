```bash
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
    *score = 0;
    *largo = 3;
    *vivo = 1;
    segmentos[0].y = 5; segmentos[0].x = 5;   /* cabeza */
    segmentos[1].y = 5; segmentos[1].x = 4;
    segmentos[2].y = 5; segmentos[2].x = 3;
    comida_idx = 0;
    *hy = 5; *hx = 5;
    int diry = 0, dirx = 1;                   /* empieza yendo a la derecha */
    int primera = 1;

    for (int i = 0; teclas[i] != '\0' && *vivo; i++) {
        int t = (unsigned char)teclas[i];
        if (t == 'q') break;

        int ndy = diry, ndx = dirx, gira = 0;
        if (t == 'w' || t == KEY_UP)    { ndy = -1; ndx = 0; gira = 1; }
        if (t == 's' || t == KEY_DOWN)  { ndy = 1;  ndx = 0; gira = 1; }
        if (t == 'a' || t == KEY_LEFT)  { ndy = 0;  ndx = -1; gira = 1; }
        if (t == 'd' || t == KEY_RIGHT) { ndy = 0;  ndx = 1; gira = 1; }
        if (!gira) continue;                 /* tecla desconocida: no mueve */
        if (!primera && ndy == -diry && ndx == -dirx) continue;  /* sin 180° */
        diry = ndy;
        dirx = ndx;
        primera = 0;

        int ny = *hy + diry;                 /* 1) nueva cabeza */
        int nx = *hx + dirx;
        if (ny < 0 || ny >= ALTO || nx < 0 || nx >= ANCHO) {   /* 2) pared */
            *hy = ny; *hx = nx;
            *vivo = 0;
            break;
        }
        for (int s = 1; s < *largo; s++)     /* 3) auto-choque contra el cuerpo */
            if (segmentos[s].y == ny && segmentos[s].x == nx) {
                *hy = ny; *hx = nx;
                *vivo = 0;
                break;
            }
        if (!*vivo) break;
        int come = (comida_idx < 3 &&         /* 4) ¿la nueva cabeza come? */
                    ny == comidas[comida_idx].y && nx == comidas[comida_idx].x);
        if (come) {
            (*score)++;
            comida_idx++;
        }
        for (int s = *largo - 1; s >= 0; s--) /* 5) desplaza; si comió, crece */
            segmentos[s + 1] = segmentos[s];
        segmentos[0].y = ny;
        segmentos[0].x = nx;
        if (come) (*largo)++;
        *hy = ny;
        *hx = nx;
    }
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
```

El truco clave es tratar la partida como una función pura: `jugar` no usa `getch` ni dibuja, solo recorre la cadena de teclas y actualiza el estado (segmentos, comida, score, vivo, cabeza). Eso hace la partida **determinista**: las mismas teclas producen siempre el mismo resultado, que es lo que permite probarla carácter a carácter.

Mover sin comer es desplazar el array desde el final (`segmentos[s + 1] = segmentos[s]`) y luego poner la cabeza en `segmentos[0]`: la cola se pierde sola porque `largo` no cambia. Si comió, `largo` suma 1 después del desplazamiento, así que la posición de la cola antigua sí se conserva y el animal crece. El orden de comprobaciones (pared → auto-choque → comida → actualizar) es el que evita el clásico bug de dibujar la cabeza fuera de la rejilla o de dar un paso después de morir.
