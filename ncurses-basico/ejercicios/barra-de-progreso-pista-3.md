Estructura final:

```c
timeout(1);
for (int paso = 0; paso < 20; paso++) {
    mvaddch(2, 2 + paso, '#');
    refresh();
    getch();
}
mvprintw(0, 0, "100%");
refresh();
```
