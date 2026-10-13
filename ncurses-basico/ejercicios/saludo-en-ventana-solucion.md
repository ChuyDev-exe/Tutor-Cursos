```bash
#!/usr/bin/env bash
set -euo pipefail

cat > saludo.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

/* Dibuja una ventana con borde y el saludo dentro. Devuelve la ventana. */
static WINDOW *dibujar_saludo(const char *nombre) {
    WINDOW *ventana = newwin(5, 30, 0, 0);
    box(ventana, 0, 0);
    mvwprintw(ventana, 2, 2, "Hola, %s", nombre);
    wrefresh(ventana);
    return ventana;
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout lo que quedó en la ventana. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    char nombre[64] = "";
    if (!fgets(nombre, sizeof nombre, stdin)) return 0;
    nombre[strcspn(nombre, "\r\n")] = '\0';

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }

    WINDOW *ventana = dibujar_saludo(nombre);
    char linea[32] = "";
    int con_borde = 0;
    if (ventana) {
        con_borde = (mvwinch(ventana, 0, 0) & A_CHARTEXT) == (ACS_ULCORNER & A_CHARTEXT);
        mvwinnstr(ventana, 2, 2, linea, 26);
        delwin(ventana);
    }
    endwin();
    delscreen(pantalla);

    for (int i = (int)strlen(linea) - 1; i >= 0 && linea[i] == ' '; i--) linea[i] = '\0';
    printf("borde: %s\ntexto: %s\n", con_borde ? "si" : "no", linea);
    return 0;
}
C

gcc saludo.c -lncurses -o saludo
./saludo 2>/dev/null
```

`newwin(filas, columnas, y, x)` crea la ventana: primero el tamaño y después la posición, siempre con la fila antes que la columna. `box(ventana, 0, 0)` dibuja el borde con los caracteres por defecto. `mvwprintw` escribe dentro de la ventana con coordenadas relativas a su esquina, y `wrefresh` pasa los cambios a la pantalla.
