Estructura casi completa:

```c
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
```
