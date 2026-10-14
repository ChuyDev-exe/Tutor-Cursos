```bash
#!/usr/bin/env bash
set -euo pipefail

cat > termometro_uso.c <<'C'
#include <ncurses.h>
#include <stdio.h>

/* Dibuja el termómetro de uso en la fila 3: 20 celdas a partir de la columna 1.
   Celda llena = '#' con el color del semáforo; celda vacía = '-' sin color. */
void pintar_termometro(int porcentaje) {
    if (porcentaje < 0) porcentaje = 0;
    if (porcentaje > 100) porcentaje = 100;
    int relleno = porcentaje / 5;
    int pareja = 1;
    if (porcentaje >= 85) pareja = 3;
    else if (porcentaje >= 60) pareja = 2;
    for (int i = 0; i < 20; i++) {
        if (i < relleno) {
            attron(COLOR_PAIR(pareja));
            mvaddch(3, 1 + i, '#');
            attroff(COLOR_PAIR(pareja));
        } else {
            mvaddch(3, 1 + i, '-');
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

int main(void) {
    int porcentaje = 0;
    if (scanf("%d", &porcentaje) != 1) return 0;

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    resizeterm(24, 80);
    if (has_colors()) {
        start_color();
        init_pair(1, COLOR_GREEN, COLOR_BLACK);
        init_pair(2, COLOR_YELLOW, COLOR_BLACK);
        init_pair(3, COLOR_RED, COLOR_BLACK);
    }

    pintar_termometro(porcentaje);

    int relleno = 0;
    for (int i = 0; i < 20; i++)
        if ((mvinch(3, 1 + i) & A_CHARTEXT) == '#') relleno++;
    int pareja = 0;
    if (relleno > 0) pareja = PAIR_NUMBER(mvinch(3, 1) & A_COLOR);
    const char *color = "ninguno";
    if (pareja == 1) color = "verde";
    else if (pareja == 2) color = "amarillo";
    else if (pareja == 3) color = "rojo";
    char barra[32];
    mvinnstr(3, 1, barra, 20);
    barra[20] = '\0';
    endwin();
    delscreen(pantalla);

    printf("relleno=%d\ncolor=%s\nbarra=%s\n", relleno, color, barra);
    return 0;
}
C

gcc termometro_uso.c -lncurses -o termometro_uso
./termometro_uso 2>/dev/null
```

La clave es el orden: se elige la pareja una sola vez (depende solo del porcentaje) y se enciende y apaga alrededor de cada `#`. Los guiones se escriben sin color, y por eso una barra vacía no tiene pareja: el andamiaje la reporta como `ninguno`.

`mvaddch(3, 1 + i, '#')` escribe un carácter en una posición concreta. Alternativamente puedes usar `mvprintw(3, 1 + i, "#")`; hacen lo mismo.
