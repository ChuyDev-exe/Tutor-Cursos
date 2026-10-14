```bash
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

    echo();
    mvprintw(1, 1, "Nombre:");
    mvprintw(3, 1, "Correo:");
    mvprintw(5, 1, "Edad:");
    refresh();

    wmove(stdscr, 1, 9);
    wgetnstr(stdscr, nombre, 10);
    wmove(stdscr, 3, 9);
    wgetnstr(stdscr, correo, 20);
    wmove(stdscr, 5, 8);
    wgetnstr(stdscr, edad_txt, 3);

    int correo_ok = strchr(correo, '@') != NULL;
    int digitos_ok = (edad_txt[0] != '\0');
    for (int i = 0; edad_txt[i] != '\0'; i++)
        if (!isdigit((unsigned char)edad_txt[i])) digitos_ok = 0;
    if (digitos_ok) *edad = (int)strtol(edad_txt, NULL, 10);
    *valido = (correo_ok && *edad > 0 && *edad < 150) ? 1 : 0;
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
```

El patrón de formulario siempre es el mismo: **colocar el cursor con `wmove`, leer con `wgetnstr` y validar antes de usar el dato**. `wgetnstr(stdscr, buffer, max)` lee hasta Enter o `max` caracteres, descarta el resto de la línea y añade el `\0`; por eso los buffers del andamiaje miden 32 aunque solo se lean 10 o 20 caracteres.

La validación no se delega: el correo debe contener `@` (`strchr`) y la edad debe ser no vacía, solo dígitos (`isdigit` en bucle) y estar entre 1 y 149. Si los dígitos no son válidos, `*edad` se queda en 0; el número leído se guarda aunque el correo esté mal, para que el informe de errores sea útil.
