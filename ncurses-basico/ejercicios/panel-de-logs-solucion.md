```bash
#!/usr/bin/env bash
set -euo pipefail

cat > panel_logs.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <string.h>

/* Los dos paneles que crea el alumno; el andamiaje los lee al terminar. */
static WINDOW *panel_info = NULL;
static WINDOW *panel_err = NULL;

/* Vista dividida: panel INFO a la izquierda y panel ERRORES a la derecha. */
void dibujar_paneles(char **info, int n_info, char **errores, int n_err) {
    panel_info = derwin(stdscr, 8, 38, 0, 0);
    panel_err = derwin(stdscr, 8, 38, 0, 40);
    box(panel_info, 0, 0);
    box(panel_err, 0, 0);
    mvwprintw(panel_info, 0, 2, "INFO");
    mvwprintw(panel_err, 0, 2, "ERRORES");
    for (int j = 0; j < n_info && j < 6; j++)
        mvwprintw(panel_info, 1 + j, 1, "%s", info[j]);
    for (int j = 0; j < n_err && j < 6; j++)
        mvwprintw(panel_err, 1 + j, 1, "%s", errores[j]);
    wrefresh(panel_info);
    wrefresh(panel_err);
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

/* Lee el título de un panel: desde la columna 2 hasta el primer carácter de borde. */
static void leer_titulo(WINDOW *p, char *dst, int max) {
    int n = 0;
    for (int x = 2; x < 2 + max; x++) {
        chtype c = mvwinch(p, 0, x);
        if ((c & A_CHARTEXT) == (ACS_HLINE & A_CHARTEXT)) break;
        if (n < max - 1) dst[n++] = (char)(c & A_CHARTEXT);
    }
    dst[n] = '\0';
    recortar(dst);
}

/* Junta las filas 1..6 del panel con ';' (sin las que estén vacías). */
static void leer_contenido(WINDOW *p, char *dst, int max) {
    int n = 0;
    for (int f = 1; f <= 6; f++) {
        char buf[64];
        mvwinnstr(p, f, 1, buf, 36);
        buf[36] = '\0';
        recortar(buf);
        if (!buf[0]) continue;
        if (n) dst[n++] = ';';
        int tam = (int)strlen(buf);
        if (n + tam > max - 1) tam = max - 1 - n;
        memcpy(dst + n, buf, tam);
        n += tam;
    }
    dst[n] = '\0';
}

int main(void) {
    int a = 0, b = 0;
    char cabecera[64] = "";
    if (!fgets(cabecera, sizeof cabecera, stdin)) return 0;
    if (sscanf(cabecera, "%d %d", &a, &b) != 2) { a = 0; b = 0; }
    if (a < 0) a = 0;
    if (b < 0) b = 0;
    if (a > 63) a = 63;
    if (b > 63) b = 63;

    static char almacen[128][128];
    static char *info[64];
    static char *errores[64];
    for (int i = 0; i < a + b; i++) {
        if (!fgets(almacen[i], sizeof almacen[0], stdin)) almacen[i][0] = '\0';
        almacen[i][strcspn(almacen[i], "\r\n")] = '\0';
        if (i < a) info[i] = almacen[i];
        else errores[i - a] = almacen[i];
    }

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    resizeterm(8, 80);

    dibujar_paneles(info, a, errores, b);

    char tit_info[16] = "", tit_err[16] = "";
    char cont_info[512] = "", cont_err[512] = "";
    if (panel_info) {
        leer_titulo(panel_info, tit_info, sizeof tit_info);
        leer_contenido(panel_info, cont_info, sizeof cont_info);
    }
    if (panel_err) {
        leer_titulo(panel_err, tit_err, sizeof tit_err);
        leer_contenido(panel_err, cont_err, sizeof cont_err);
    }
    if (panel_info) delwin(panel_info);
    if (panel_err) delwin(panel_err);
    endwin();
    delscreen(pantalla);

    printf("info=titulo:%s;%s\n", tit_info, cont_info);
    printf("errores=titulo:%s;%s\n", tit_err, cont_err);
    return 0;
}
C

gcc panel_logs.c -lncurses -o panel_logs
./panel_logs 2>/dev/null
```

`derwin` crea una ventana con las mismas coordenadas que su madre pero con contenido propio: `derwin(stdscr, 8, 38, 0, 40)` empieza en la columna 40 de la pantalla. Por eso las funciones llevan `w` (`mvwprintw`, `wrefresh`) y las coordenadas son relativas al panel.

El orden de borrado importa: primero `delwin` de las hijas (`panel_info`, `panel_err`) y después `endwin`/`delscreen`, que se lleva por delante a `stdscr`.
