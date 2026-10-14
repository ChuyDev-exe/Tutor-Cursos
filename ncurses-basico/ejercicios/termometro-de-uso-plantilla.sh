#!/usr/bin/env bash
set -euo pipefail

cat > termometro_uso.c <<'C'
#include <ncurses.h>
#include <stdio.h>

/* Dibuja el termómetro de uso en la fila 3: 20 celdas a partir de la columna 1.
   Celda llena = '#' con el color del semáforo; celda vacía = '-' sin color. */
void pintar_termometro(int porcentaje) {
    // TODO 1: calcula las celdas llenas: relleno = porcentaje / 5 (división entera, hacia abajo),
    //         sin pasar de 0 ni de 20
    // TODO 2: elige la pareja de color: 1 (verde) si p < 60, 2 (amarilla) si 60 <= p < 85,
    //         3 (roja) si p >= 85
    // TODO 3: recorre las 20 celdas (fila 3, columna 1 + i):
    //         si i < relleno → escribe '#' con attron(COLOR_PAIR(pareja)) … attroff
    //         si no → escribe '-' sin color
    // TODO 4: muestra los cambios con refresh
    (void)porcentaje;
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en ella. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    int porcentaje = 0;
    if (scanf("%d", &porcentaje) != 1) return 0;

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    resizeterm(24, 80);
    if (has_colors()) {
        start_color();
        init_pair(1, COLOR_GREEN, COLOR_BLACK);
        init_pair(2, COLOR_YELLOW, COLOR_BLACK);
        init_pair(3, COLOR_RED, COLOR_BLACK);
    }

    pintar_termometro(porcentaje);

    int relleno = 0;
    for (int i = 0; i < 20; i++)
        if ((mvinch(3, 1 + i) & A_CHARTEXT) == '#') relleno++;
    int pareja = 0;
    if (relleno > 0) pareja = PAIR_NUMBER(mvinch(3, 1) & A_COLOR);
    const char *color = "ninguno";
    if (pareja == 1) color = "verde";
    else if (pareja == 2) color = "amarillo";
    else if (pareja == 3) color = "rojo";
    char barra[32];
    mvinnstr(3, 1, barra, 20);
    barra[20] = '\0';
    endwin();
    delscreen(pantalla);

    printf("relleno=%d\ncolor=%s\nbarra=%s\n", relleno, color, barra);
    return 0;
}
C

gcc termometro_uso.c -lncurses -o termometro_uso
./termometro_uso 2>/dev/null
