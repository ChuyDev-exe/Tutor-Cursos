#!/usr/bin/env bash
set -euo pipefail

cat > productos.txt <<'EOF'
manzana 12 3
platano 7 2
uvas 20 8
pera 5 6
kiwi 30 4
melon 2 9
naranja 15 1
fresa 9 5
EOF

cat > tabla_ordenable.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_PROD 8

typedef struct {
    char nombre[16];
    int cantidad;
    int precio;
} Producto;

/* 1 = nombre, 2 = cantidad, 3 = precio: lo decides en gestionar. */
static int campo_orden = 0;

/* Comparador para qsort: usa campo_orden para saber qué campo mirar. */
static int comparar(const void *a, const void *b) {
    (void)a;
    (void)b;
    // TODO 1: convierte a y b a const Producto *.
    //         Si campo_orden == 1: devuelve strcmp(nombre, nombre).
    //         Si campo_orden == 2: compara cantidad (menor <, mayor >, igual = 0).
    //         Si campo_orden == 3: compara precio igual que la cantidad.
    return 0;
}

/* Gestiona el inventario: dibuja la tabla y la reordena con n, c, p. */
static void gestionar(Producto *p, int n) {
    (void)p;
    (void)n;
    // TODO 2: en un bucle for (;;) primero se dibuja y luego se lee la tecla:
    //         - cabecera: mvprintw(0, 2, "n=nombre c=cantidad p=precio")
    //         - tabla: para i en 0..n-1,
    //           mvprintw(2 + i, 2, "%-10s %3d %3d", p[i].nombre, p[i].cantidad, p[i].precio)
    //         - refresh();
    // TODO 3: lee la tecla con getch():
    //         'n' → campo_orden = 1, 'c' → 2, 'p' → 3;
    //         solo 'q' o ERR terminan el bucle con break; cualquier otra tecla
    //         (ojo: tras resizeterm la primera es KEY_RESIZE, que hay que ignorar)
    //         no ordena y simplemente vuelve a repintar
    // TODO 4: si la tecla era n, c o p: qsort(p, n, sizeof(Producto), comparar)
    //         y werase(stdscr) para que el bucle repinte entero.
    //         No llames a qsort con el campo sin cambiar: un comparador que
    //         devuelve 0 siempre puede barajar el array.
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout el estado. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    Producto prod[MAX_PROD];
    int n = 0;
    FILE *f = fopen("productos.txt", "r");
    if (f) {
        while (n < MAX_PROD &&
               fscanf(f, "%15s %d %d", prod[n].nombre, &prod[n].cantidad, &prod[n].precio) == 3)
            n++;
        fclose(f);
    }

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    resizeterm(14, 40);

    gestionar(prod, n);

    char salida[MAX_PROD][64];
    for (int i = 0; i < n; i++) {
        char fila[32] = {0};
        char nom[16] = {0};
        int cant = 0, precio = 0;
        mvinnstr(2 + i, 2, fila, 20);
        if (sscanf(fila, "%15s %d %d", nom, &cant, &precio) != 3) {
            nom[0] = '\0';
            cant = 0;
            precio = 0;
        }
        snprintf(salida[i], sizeof salida[i], "fila=%s|%d|%d", nom, cant, precio);
    }

    endwin();
    delscreen(pantalla);

    for (int i = 0; i < n; i++) printf("%s\n", salida[i]);
    return 0;
}
C

gcc tabla_ordenable.c -lncurses -o tabla_ordenable
./tabla_ordenable 2>/dev/null
