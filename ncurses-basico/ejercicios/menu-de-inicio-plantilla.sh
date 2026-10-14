#!/usr/bin/env bash
set -euo pipefail

cat > menu_inicio.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Dibuja las n opciones en las filas 1..n de stdscr y deja que el usuario
   elija con j/k (o flechas). Devuelve el índice de la opción elegida. */
int elegir_opcion(const char **opciones, int n) {
    // TODO 1: repinta las n opciones en la fila i+1, columna 2: la seleccionada
    //         con "> " delante y A_REVERSE, las demás con dos espacios ("  %s");
    //         borra con erase() antes y llama a refresh() al final
    // TODO 2: bucle con getch(); si devuelve ERR, termina el bucle
    // TODO 3: 'k' o KEY_UP sube (sin pasar de 0); 'j' o KEY_DOWN baja (sin pasar de n-1)
    // TODO 4: '\n', '\r', KEY_ENTER o 'q' terminan el bucle; las demás teclas se ignoran
    // TODO 5: devuelve el índice seleccionado
    (void)opciones;
    (void)n;
    return 0;
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en ella. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

static const char *OPCIONES[] = {"Procesos", "Discos", "Red", "Salir"};

int main(void) {
    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);

    int seleccion = elegir_opcion(OPCIONES, 4);
    if (seleccion < 0 || seleccion >= 4) seleccion = 0;

    endwin();
    delscreen(pantalla);

    printf("seleccion=%d\ntitulo=%s\n", seleccion, OPCIONES[seleccion]);
    return 0;
}
C

gcc menu_inicio.c -lncurses -o menu_inicio
./menu_inicio 2>/dev/null
