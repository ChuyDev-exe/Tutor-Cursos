```bash
#!/usr/bin/env bash
set -euo pipefail

cat > tabla_bordes.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

/* Tabla de inventario dibujada con líneas ACS: título, cabecera, separador y datos. */
void dibujar_tabla(char **filas, int n) {
    mvprintw(0, 2, "Inventario");
    mvprintw(2, 2, "Nombre");
    mvprintw(2, 16, "Cant.");
    mvprintw(2, 24, "Precio");
    mvhline(3, 1, ACS_HLINE, 32);
    mvvline(1, 0, ACS_VLINE, 3 + n);
    mvvline(1, 33, ACS_VLINE, 3 + n);
    if (n > 12) n = 12;
    for (int i = 0; i < n; i++) {
        char nombre[32], cantidad[16], precio[16];
        if (sscanf(filas[i], "%31[^,],%15[^,],%15s", nombre, cantidad, precio) == 3) {
            mvprintw(4 + i, 2, "%s", nombre);
            mvprintw(4 + i, 16, "%s", cantidad);
            mvprintw(4 + i, 24, "%s", precio);
        }
    }
    refresh();
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
```

`ACS_HLINE` y `ACS_VLINE` son los caracteres de línea «bonitos» del terminal. Nunca compares sus celdas con `'-'` o `'|'` literales: compara con `(celda & A_CHARTEXT) == (ACS_HLINE & A_CHARTEXT)`, que es como comprueba el andamiaje el separador.

`sscanf(filas[i], "%31[^,],%15[^,],%15s", nombre, cantidad, precio)` parte la línea por las comas sin tocar la original.
