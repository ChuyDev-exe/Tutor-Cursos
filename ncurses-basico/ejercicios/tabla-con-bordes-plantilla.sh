#!/usr/bin/env bash
set -euo pipefail

cat > tabla_bordes.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

/* Tabla de inventario dibujada con líneas ACS: título, cabecera, separador y datos. */
void dibujar_tabla(char **filas, int n) {
    // TODO 1: título "Inventario" en la fila 0, columna 2 (mvprintw)
    // TODO 2: cabecera en la fila 2: "Nombre" en x=2, "Cant." en x=16, "Precio" en x=24
    // TODO 3: línea horizontal bajo la cabecera: mvhline(3, 1, ACS_HLINE, 32)
    // TODO 4: líneas verticales de los laterales:
    //         mvvline(1, 0, ACS_VLINE, 3 + n) y mvvline(1, 33, ACS_VLINE, 3 + n)
    // TODO 5: cada filas[i] es "nombre,cantidad,precio"; sepáralos con sscanf("%[^,],%[^,],%s")
    //         o con strtok, y escribe: nombre en la fila 4 + i, x=2;
    //         cantidad en x=16; precio en x=24
    // TODO 6: dibuja como máximo 12 filas de datos (las filas 4 a 15)
    // TODO 7: muestra los cambios con refresh
    (void)filas; (void)n;
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en ella. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

static void recortar(char *s) {
    int n = (int)strlen(s);
    while (n > 0 && s[n - 1] == ' ') s[--n] = '\0';
}

int main(void) {
    int n = 0;
    if (scanf("%d", &n) != 1) return 0;
    if (n < 0) n = 0;
    if (n > 12) n = 12;
    static char almacen[12][64];
    static char *filas[12];
    for (int i = 0; i < n; i++) {
        if (scanf("%63s", almacen[i]) != 1) almacen[i][0] = '\0';
        filas[i] = almacen[i];
    }

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    resizeterm(20, 60);

    dibujar_tabla(filas, n);

    char col1[24], col2[12], col3[12];
    mvinnstr(2, 2, col1, 14); recortar(col1);
    mvinnstr(2, 16, col2, 7); recortar(col2);
    mvinnstr(2, 24, col3, 8); recortar(col3);
    char cab[96];
    snprintf(cab, sizeof cab, "%s|%s|%s", col1, col2, col3);

    char filas_txt[16][96];
    for (int i = 0; i < n; i++) {
        int f = 4 + i;
        mvinnstr(f, 2, col1, 13); recortar(col1);
        mvinnstr(f, 16, col2, 7); recortar(col2);
        mvinnstr(f, 24, col3, 8); recortar(col3);
        snprintf(filas_txt[i], sizeof filas_txt[i], "%s|%s|%s", col1, col2, col3);
    }

    int separador = (mvinch(3, 5) & A_CHARTEXT) == (ACS_HLINE & A_CHARTEXT);
    endwin();
    delscreen(pantalla);

    printf("cab=%s\n", cab);
    for (int i = 0; i < n; i++) printf("fila=%s\n", filas_txt[i]);
    printf("separador=%s\n", separador ? "si" : "no");
    return 0;
}
C

gcc tabla_bordes.c -lncurses -o tabla_bordes
./tabla_bordes 2>/dev/null
