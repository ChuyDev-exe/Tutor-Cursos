#!/usr/bin/env bash
set -euo pipefail

cat > formulario_de_contacto.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* Pide nombre, correo y edad con validación. Rellena *edad con el número
   leído (0 si la edad no son dígitos) y *valido con 1 o 0. */
static void pedir_contacto(char *nombre, char *correo, int *edad, int *valido) {
    char edad_txt[4];
    *edad = 0;
    *valido = 0;
    (void)correo;
    // TODO 1: activa echo() y dibuja las etiquetas con mvprintw:
    //         (1, 1) "Nombre:", (3, 1) "Correo:", (5, 1) "Edad:"; después refresh()
    // TODO 2: wmove(stdscr, 1, 9); wgetnstr(stdscr, nombre, 10);
    //         wmove(stdscr, 3, 9); wgetnstr(stdscr, correo, 20);
    //         wmove(stdscr, 5, 8); wgetnstr(stdscr, edad_txt, 3);
    // TODO 3: valida el correo: debe contener '@' (strchr)
    // TODO 4: valida la edad: no vacía, solo dígitos (isdigit en bucle) y entre 1 y 149
    //         (convierte con strtol); si no son dígitos, *edad se queda en 0
    // TODO 5: *valido = 1 solo si el correo tiene '@' Y la edad es un número entre 1 y 149
    (void)nombre;
    (void)edad_txt;
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout el estado. */
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
    resizeterm(10, 40);
    getch();   /* descarta el KEY_RESIZE que encola resizeterm */

    char nombre[32] = {0};
    char correo[32] = {0};
    int edad = 0;
    int valido = 0;
    pedir_contacto(nombre, correo, &edad, &valido);

    endwin();
    delscreen(pantalla);

    printf("nombre=%s correo=%s edad=%d valido=%s\n",
           nombre, correo, edad, valido ? "si" : "no");
    return 0;
}
C

gcc formulario_de_contacto.c -lncurses -o formulario_de_contacto
./formulario_de_contacto 2>/dev/null
