#!/usr/bin/env bash
set -euo pipefail

cat > barra_estados.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

#define N_SERVICIOS 5

/* Pinta el panel de servicios: nombre a la izquierda, bloque "[]" de color a la derecha.
   estado: 1 = verde, 2 = amarilla, 3 = roja (parejas ya creadas por el andamiaje). */
void pintar_estados(const char **nombres, const int *estados, int n) {
    for (int i = 0; i < n; i++) {
        // TODO 1: escribe nombres[i] en la fila 1 + i, columna 2 con mvprintw
        // TODO 2: enciende el color de la pareja estados[i] con attron(COLOR_PAIR(estados[i]))
        // TODO 3: escribe "[]" en la fila 1 + i, columna 20 (con el color todavía encendido)
        // TODO 4: apaga el color con attroff(COLOR_PAIR(estados[i]))
    }
    // TODO 5: muestra los cambios en pantalla con refresh
    (void)nombres; (void)estados; (void)n;
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en ella. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

static int estado_de(const char *palabra) {
    if (strcmp(palabra, "CRIT") == 0) return 3;
    if (strcmp(palabra, "WARN") == 0) return 2;
    return 1;
}

int main(void) {
    const char *nombres[N_SERVICIOS] = { "cpu", "ram", "disco", "red", "backup" };
    int estados[N_SERVICIOS] = { 1, 1, 1, 1, 1 };

    char linea[256] = "";
    if (!fgets(linea, sizeof linea, stdin)) return 0;
    char palabras[5][16] = { { 0 } };
    sscanf(linea, "%15s %15s %15s %15s %15s",
           palabras[0], palabras[1], palabras[2], palabras[3], palabras[4]);
    for (int i = 0; i < N_SERVICIOS; i++) estados[i] = estado_de(palabras[i]);

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    resizeterm(24, 80);
    if (has_colors()) {
        start_color();
        init_pair(1, COLOR_GREEN, COLOR_BLACK);
        init_pair(2, COLOR_YELLOW, COLOR_BLACK);
        init_pair(3, COLOR_RED, COLOR_BLACK);
    }

    pintar_estados(nombres, estados, N_SERVICIOS);

    char salida[N_SERVICIOS][64];
    for (int i = 0; i < N_SERVICIOS; i++) {
        chtype celda = mvinch(1 + i, 20);
        snprintf(salida[i], sizeof salida[i], "%s=%d",
                 nombres[i], PAIR_NUMBER(celda & A_COLOR));
    }
    endwin();
    delscreen(pantalla);

    for (int i = 0; i < N_SERVICIOS; i++) printf("%s\n", salida[i]);
    return 0;
}
C

gcc barra_estados.c -lncurses -o barra_estados
./barra_estados 2>/dev/null
