```bash
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

    noecho();
    mvprintw(3, 1, "Clave:");
    wmove(stdscr, 3, 8);
    wgetnstr(stdscr, clave, 10);
    echo();

    int ok = (strcmp(usuario, "admin") == 0 && strcmp(clave, "s3cret") == 0);
    if (ok) mvprintw(5, 1, "Acceso concedido");
    else    mvprintw(5, 1, "Acceso denegado");
    refresh();
    return ok;
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
```

La clave se lee con `wgetnstr` igual que el usuario, pero rodeada de `noecho()` y `echo()`: mientras dura la lectura, ncurses no escribe en pantalla lo que llega del teclado. Es el mismo `getch` de siempre; solo cambia el modo de eco, no la función de lectura.

La comprobación usa `strcmp(a, b) == 0`, que significa «las cadenas son iguales». `strcmp` no devuelve un booleano: devuelve 0 si coinciden y algo distinto de 0 si no. Comparar con `== 0` directamente contra la función es un error clásico.
