```bash
#!/usr/bin/env bash
set -euo pipefail

cat > productos.txt <<'EOF'
manzana 12 3
platano 7 2
uvas 20 8
pera 5 6
kiwi 30 4
melon 2 9
naranja 15 1
fresa 9 5
EOF

cat > tabla_ordenable.c <<'C'
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_PROD 8

typedef struct {
    char nombre[16];
    int cantidad;
    int precio;
} Producto;

/* 1 = nombre, 2 = cantidad, 3 = precio: lo decides en gestionar. */
static int campo_orden = 0;

/* Comparador para qsort: usa campo_orden para saber qué campo mirar. */
static int comparar(const void *a, const void *b) {
    const Producto *x = (const Producto *)a;
    const Producto *y = (const Producto *)b;
    if (campo_orden == 1) return strcmp(x->nombre, y->nombre);
    if (campo_orden == 2) return (x->cantidad > y->cantidad) - (x->cantidad < y->cantidad);
    if (campo_orden == 3) return (x->precio > y->precio) - (x->precio < y->precio);
    return 0;
}

/* Gestiona el inventario: dibuja la tabla y la reordena con n, c, p. */
static void gestionar(Producto *p, int n) {
    int tecla;
    for (;;) {
        mvprintw(0, 2, "n=nombre c=cantidad p=precio");
        for (int i = 0; i < n; i++)
            mvprintw(2 + i, 2, "%-10s %3d %3d", p[i].nombre, p[i].cantidad, p[i].precio);
        refresh();
        tecla = getch();
        if (tecla == 'n' || tecla == 'c' || tecla == 'p') {
            campo_orden = (tecla == 'n') ? 1 : (tecla == 'c') ? 2 : 3;
            qsort(p, n, sizeof(Producto), comparar);
            werase(stdscr);
        } else if (tecla == 'q' || tecla == ERR) {
            break;
        }
    }
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* La pantalla se dibuja en stderr; al terminar se imprime en stdout el estado. */
static SCREEN *abrir_pantalla(void) {
    SCREEN *pantalla = newterm(NULL, stderr, stdin);
    if (!pantalla) pantalla = newterm("xterm", stderr, stdin);
    return pantalla;
}

int main(void) {
    Producto prod[MAX_PROD];
    int n = 0;
    FILE *f = fopen("productos.txt", "r");
    if (f) {
        while (n < MAX_PROD &&
               fscanf(f, "%15s %d %d", prod[n].nombre, &prod[n].cantidad, &prod[n].precio) == 3)
            n++;
        fclose(f);
    }

    SCREEN *pantalla = abrir_pantalla();
    if (!pantalla) { printf("No se pudo abrir la pantalla\n"); return 1; }
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    resizeterm(14, 40);

    gestionar(prod, n);

    char salida[MAX_PROD][64];
    for (int i = 0; i < n; i++) {
        char fila[32] = {0};
        char nom[16] = {0};
        int cant = 0, precio = 0;
        mvinnstr(2 + i, 2, fila, 20);
        if (sscanf(fila, "%15s %d %d", nom, &cant, &precio) != 3) {
            nom[0] = '\0';
            cant = 0;
            precio = 0;
        }
        snprintf(salida[i], sizeof salida[i], "fila=%s|%d|%d", nom, cant, precio);
    }

    endwin();
    delscreen(pantalla);

    for (int i = 0; i < n; i++) printf("%s\n", salida[i]);
    return 0;
}
C

gcc tabla_ordenable.c -lncurses -o tabla_ordenable
./tabla_ordenable 2>/dev/null
```

El truco clave es separar «qué campo ordena» del comparador: la variable global `campo_orden` (1, 2 o 3) la pone la tecla que pulse el alumno y la lee `comparar`, que así sabe si devolver `strcmp` de nombres o la resta de dos enteros. `qsort` ordena el array **in-place**: el orden original desaparece, por eso cada orden se hace en una sola dirección y la tabla se repinta entera con `werase` más dibujo.

La estructura `for (;;) { dibuja; tecla; si no ordena, break; qsort; werase; }` evita duplicar el dibujo: la misma tira de código pinta la tabla al principio y después de cada orden, y el bucle termina solo con `q` o con `ERR`. Detalle real: justo después de `resizeterm`, la primera `getch()` devuelve `KEY_RESIZE` (410), que no es `ERR`; si hicieras `break` con cualquier otra tecla, la tabla se cerraría sola al arrancar.
