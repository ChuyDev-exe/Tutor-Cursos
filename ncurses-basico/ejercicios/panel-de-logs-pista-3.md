Estructura casi completa:

```c
panel_info = derwin(stdscr, 8, 38, 0, 0);
panel_err = derwin(stdscr, 8, 38, 0, 40);
box(panel_info, 0, 0);
box(panel_err, 0, 0);
mvwprintw(panel_info, 0, 2, "INFO");
mvwprintw(panel_err, 0, 2, "ERRORES");
for (int j = 0; j < n_info && j < 6; j++)
    mvwprintw(panel_info, 1 + j, 1, "%s", info[j]);
// … lo mismo con errores en panel_err …
wrefresh(panel_info);
wrefresh(panel_err);
```
