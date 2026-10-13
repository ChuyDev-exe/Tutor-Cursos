Estructura casi completa:

```c
int tecla;
while ((tecla = getch()) != 'q' && tecla != ERR) {
    mvaddch(*y, *x, ' ');
    if (tecla == 'w' && *y > 0) (*y)--;
    // … las otras tres teclas, con su borde
    mvaddch(*y, *x, '@');
    refresh();
}
```
