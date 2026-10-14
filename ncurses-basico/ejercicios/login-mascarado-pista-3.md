Estructura casi completa:

```c
noecho();
mvprintw(3, 1, "Clave:");
wmove(stdscr, 3, 8);
wgetnstr(stdscr, clave, 10);
echo();
int ok = (strcmp(usuario, "admin") == 0 && strcmp(clave, "s3cret") == 0);
```
