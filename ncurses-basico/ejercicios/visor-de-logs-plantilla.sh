#!/usr/bin/env bash
set -euo pipefail

cat > logs.txt <<'EOF'
2026-01-03 10:00 INFO servicio 00
2026-01-03 10:01 INFO servicio 01
2026-01-03 10:02 INFO servicio 02
2026-01-03 10:03 INFO servicio 03
2026-01-03 10:04 INFO servicio 04
2026-01-03 10:05 INFO servicio 05
2026-01-03 10:06 INFO servicio 06
2026-01-03 10:07 INFO servicio 07
2026-01-03 10:08 INFO servicio 08
2026-01-03 10:09 INFO servicio 09
2026-01-03 10:10 INFO servicio 10
2026-01-03 10:11 INFO servicio 11
2026-01-03 10:12 INFO servicio 12
2026-01-03 10:13 INFO servicio 13
2026-01-03 10:14 INFO servicio 14
2026-01-03 10:15 INFO servicio 15
2026-01-03 10:16 INFO servicio 16
2026-01-03 10:17 INFO servicio 17
2026-01-03 10:18 INFO servicio 18
2026-01-03 10:19 INFO servicio 19
2026-01-03 10:20 INFO servicio 20
2026-01-03 10:21 INFO servicio 21
2026-01-03 10:22 INFO servicio 22
2026-01-03 10:23 INFO servicio 23
2026-01-03 10:24 INFO servicio 24
EOF

cat > visor_de_logs.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINEAS 25
#define LARGO_LINEA 40
#define FILAS_VIS 4

/* La ventana visora la crea ver_logs; el andamiaje la lee al terminar. */
static WINDOW *vista = NULL;

/* Visor de un log con barra de estado, como less o journalctl.
   top es la primera línea visible; j/k bajan y suben. */
static void ver_logs(char lineas[][LARGO_LINEA], int n) {
    (void)lineas;
    (void)n;
    // TODO 1: crea la ventana: vista = newwin(6, 35, 0, 0)
    // TODO 2: top = 0 y bucle de repintado:
    //         - box(vista, 0, 0) y título "logs" en la fila 0, columna 2 de la ventana
    //         - filas 1..4 de la ventana con lineas[top] .. lineas[top+3]:
    //           mvwprintw(vista, 1 + i, 1, "%s", lineas[top + i]), sin dibujar más allá de n
    //         - barra de estado en stdscr: mvprintw(7, 0, "linea %d-%d de %d", ...)
    //           (empieza en top + 1 y termina en top + 4 sin pasar de n)
    //         - wrefresh(vista); refresh();
    // TODO 3: lee teclas con getch(): 'j' o KEY_DOWN sube top 1 (máximo n - FILAS_VIS);
    //         'k' o KEY_UP lo baja 1 (mínimo 0); 'q' o ERR terminan el bucle
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

static void recortar_dcha(char *s) {
    size_t n = strlen(s);
    while (n > 0 && s[n - 1] == ' ') s[--n] = '\0';
}

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout el estado. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    char lineas[MAX_LINEAS][LARGO_LINEA];
    int n = 0;
    FILE *f = fopen("logs.txt", "r");
    if (f) {
        char buf[64];
        while (n < MAX_LINEAS && fgets(buf, sizeof buf, f)) {
            buf[strcspn(buf, "\n")] = '\0';
            snprintf(lineas[n], LARGO_LINEA, "%s", buf);
            n++;
        }
        fclose(f);
    }

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    resizeterm(8, 36);

    ver_logs(lineas, n);

    char primera[64] = {0};
    char ultima[64] = {0};
    char estado[64] = {0};
    if (vista) {
        mvwinnstr(vista, 1, 1, primera, 33);
        mvwinnstr(vista, FILAS_VIS, 1, ultima, 33);
    }
    mvinnstr(7, 0, estado, 30);
    recortar_dcha(primera);
    recortar_dcha(ultima);
    recortar_dcha(estado);

    if (vista) delwin(vista);
    endwin();
    delscreen(pantalla);

    printf("primera=%s\nultima=%s\nestado=%s\n", primera, ultima, estado);
    return 0;
}
C

gcc visor_de_logs.c -lncurses -o visor_de_logs
./visor_de_logs 2>/dev/null
