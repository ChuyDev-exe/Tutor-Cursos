#!/usr/bin/env bash
set -euo pipefail

cat > login_mascarado.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Login de dos pasos: el usuario ya está leído; falta la clave (sin eco)
   y la comprobación. Devuelve 1 si las credenciales son las correctas. */
static int verificar_login(char *usuario) {
    char clave[11];
    // TODO 1: pide la clave sin eco: noecho(); mvprintw(3, 1, "Clave:");
    //         wmove(stdscr, 3, 8); wgetnstr(stdscr, clave, 10); echo();
    // TODO 2: comprueba con strcmp que usuario es "admin" y clave es "s3cret"
    // TODO 3: dibuja en la fila 5, columna 1 "Acceso concedido" o "Acceso denegado"
    //         y muestra los cambios con refresh()
    // TODO 4: devuelve 1 si todo coincide, 0 si no
    (void)usuario;
    (void)clave;
    return 0;
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
    resizeterm(8, 40);
    getch();   /* descarta el KEY_RESIZE que encola resizeterm */

    char usuario[32] = {0};
    echo();
    mvprintw(1, 1, "Usuario:");
    wmove(stdscr, 1, 10);
    wgetnstr(stdscr, usuario, 10);
    refresh();

    int ok = verificar_login(usuario);

    endwin();
    delscreen(pantalla);

    printf("usuario=%s clave=*** acceso=%s\n", usuario, ok ? "concedido" : "denegado");
    return 0;
}
C

gcc login_mascarado.c -lncurses -o login_mascarado
./login_mascarado 2>/dev/null
