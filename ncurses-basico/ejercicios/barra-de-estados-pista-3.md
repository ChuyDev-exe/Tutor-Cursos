Estructura casi completa:

```c
for (int i = 0; i < n; i++) {
    mvprintw(1 + i, 2, "%s", nombres[i]);
    attron(COLOR_PAIR(estados[i]));
    mvprintw(1 + i, 20, "[]");
    attroff(COLOR_PAIR(estados[i]));
}
refresh();
```
