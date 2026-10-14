Estructura casi completa:

```c
int tecla;
while ((tecla = getch()) != 'q' && tecla != ERR) {
    if ((tecla == 'j' || tecla == KEY_DOWN) && *top < 25) (*top)++;
    // … la otra tecla con su borde …
    prefresh(pad, *top, 0, 0, 0, 4, 14);
}
```
