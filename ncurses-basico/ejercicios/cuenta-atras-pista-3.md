Bucle principal:

```c
timeout(1);
for (int restante = segundos; restante >= 0; restante--) {
    mvprintw(1, 1, "quedan %2d s", restante);
    mvhline(3, 1, ' ', COLS - 1);
    for (int i = 0; i < restante && 1 + i < COLS; i++)
        mvaddch(3, 1 + i, '#');
    refresh();
    getch();
}
```
