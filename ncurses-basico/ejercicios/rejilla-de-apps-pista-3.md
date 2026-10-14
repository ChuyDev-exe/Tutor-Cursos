Estructura del bucle:

```c
for (;;) {
    werase(stdscr);
    for (int i = 0; i < n; i++) {
        int f = fila_base + i / COLS_GRID;
        int x = 2 + (i % COLS_GRID) * ANCHO_CELDA;
        if (i == sel) attron(A_REVERSE);
        mvprintw(f, x, "%s", apps[i]);
        if (i == sel) attroff(A_REVERSE);
    }
    refresh();
    int tecla = getch();
    if (tecla == '\\n' || tecla == 'q' || tecla == KEY_ENTER || tecla == ERR) break;
    /* ... mueve fila/col con h/j/k/l y recalcula sel ... */
}
return sel;
```
