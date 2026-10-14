#!/usr/bin/env bash
set -euo pipefail

cat > calculadora.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DISPLAY_TAM 32

/* Procesa la cadena de teclas y deja en display el texto visible
   (fase 0: "%ld", fase 1: "%ld %c", fase 2: "%ld %c %ld").
   Devuelve el valor final de la calculadora. */
long calcular(const char *teclas, char *display) {
    // TODO 1: estado inicial: izq y der (long) a 0, op (char) a 0, fase (int) a 0
    // TODO 2: recorre teclas carácter a carácter con un for
    // TODO 3: '0'-'9': fase 0 acumula en izq, fase 2 acumula en der, fase 1 se ignora
    // TODO 4: operador: en fase 0/1 guarda op y pasa a fase 2 con der=0;
    //         en fase 2 aplica primero la operación pendiente sobre izq y luego guarda op
    // TODO 5: 'c' reinicia todo; '=' en fase 2 aplica, vuelve a fase 0 y muestra el resultado
    //         (división entera; si der es 0, el resultado es 0)
    // TODO 6: tras cada tecla actualiza display con snprintf(display, DISPLAY_TAM, ...)
    // TODO 7: devuelve izq
    (void)teclas;
    (void)display;
    return 0;
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en ella. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    char teclas[256];
    if (!fgets(teclas, sizeof teclas, stdin)) teclas[0] = '\0';

    char display[DISPLAY_TAM] = "0";
    long resultado = calcular(teclas, display);

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);

    WINDOW *marco = newwin(3, 44, 0, 0);
    box(marco, 0, 0);
    mvwprintw(marco, 1, 2, "%s", display);
    wrefresh(marco);
    getch();   /* en la terminal real, espera una tecla para ver el resultado */

    endwin();
    delwin(marco);
    delscreen(pantalla);

    printf("pantalla=%s\nresultado=%ld\n", display, resultado);
    return 0;
}
C

gcc calculadora.c -lncurses -o calculadora
./calculadora 2>/dev/null
