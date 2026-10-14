Estructura del bucle:

```c
int sel = 0;
while (1) {
    erase();
    for (int i = 0; i < n; i++) {
        if (i == sel) { attron(A_REVERSE); mvprintw(i + 1, 2, "> %s", opciones[i]); attroff(A_REVERSE); }
        else mvprintw(i + 1, 2, "  %s", opciones[i]);
    }
    refresh();
    int tecla = getch();
    // … ERR termina; k/KEY_UP, j/KEY_DOWN mueven; '\n', KEY_ENTER o 'q' terminan
}
return sel;
```
