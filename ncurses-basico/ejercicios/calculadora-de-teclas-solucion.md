```bash
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
    long izq = 0, der = 0;
    char op = 0;
    int fase = 0;

    for (int i = 0; teclas[i] != '\0'; i++) {
        char c = teclas[i];
        int es_operador = (c == '+' || c == '-' || c == '*' || c == '/');

        if (es_operador || c == '=') {
            if (fase == 2) {   /* había una operación pendiente: aplícala */
                if (op == '+') izq += der;
                else if (op == '-') izq -= der;
                else if (op == '*') izq *= der;
                else if (op == '/') izq = (der == 0) ? 0 : izq / der;
                der = 0;
                if (c == '=') fase = 0;   /* el resultado queda en izq */
            }
            if (es_operador) { op = c; der = 0; fase = 2; }
        } else if (c == 'c') {
            izq = 0; der = 0; op = 0; fase = 0;
        } else if (c >= '0' && c <= '9') {
            if (fase == 0) izq = izq * 10 + (c - '0');
            else if (fase == 2) der = der * 10 + (c - '0');
        }

        if (fase == 0) snprintf(display, DISPLAY_TAM, "%ld", izq);
        else if (fase == 1) snprintf(display, DISPLAY_TAM, "%ld %c", izq, op);
        else snprintf(display, DISPLAY_TAM, "%ld %c %ld", izq, op, der);
    }
    return izq;
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
```

El truco es que **un operador en fase 2 aplica lo pendiente antes de guardarse**: así `2+3=*10=` encadena sin pensar en nada más (5 y luego 50), y un `=` en fase 2 hace lo mismo pero deja la fase en 0. El `display` se recalcula al final de cada vuelta con `snprintf`, que por el límite de `DISPLAY_TAM` nunca desborda el búfer.
