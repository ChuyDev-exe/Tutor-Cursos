Estructura casi completa:

```c
while ((tecla = getch()) != 'q' && tecla != ERR) {
    if ((tecla == 'l' || tecla == KEY_RIGHT) && *izq < 36) *izq += 4;
    if ((tecla == 'h' || tecla == KEY_LEFT) && *izq > 0) *izq -= 4;
    prefresh(pad, 0, *izq, 0, 0, 6, 11);
}
```
