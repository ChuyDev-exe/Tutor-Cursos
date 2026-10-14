La barra de estado no va en la ventana sino en `stdscr`: `mvprintw(7, 0, "linea %d-%d de %d", top + 1, fin, n)`. Repíntala en cada vuelta del bucle, junto con la ventana: si la olvidas, el usuario ve una posición que ya no es la real.

Estructura del bucle:

```c
int tecla;
do {
    box(vista, 0, 0);
    mvwprintw(vista, 0, 2, "logs");
    for (int i = 0; i < FILAS_VIS; i++)
        if (top + i < n) mvwprintw(vista, 1 + i, 1, "%s", lineas[top + i]);
    wrefresh(vista);
    mvprintw(7, 0, "linea %d-%d de %d", top + 1, top + 4, n);
    refresh();
    tecla = getch();
    // … actualiza top con clamp …
} while (tecla != 'q' && tecla != ERR);
```
