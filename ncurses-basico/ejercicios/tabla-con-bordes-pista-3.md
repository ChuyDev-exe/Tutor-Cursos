Estructura casi completa:

```c
mvprintw(0, 2, "Inventario");
mvprintw(2, 2, "Nombre");
mvprintw(2, 16, "Cant.");
mvprintw(2, 24, "Precio");
mvhline(3, 1, ACS_HLINE, 32);
mvvline(1, 0, ACS_VLINE, 3 + n);
mvvline(1, 33, ACS_VLINE, 3 + n);
for (int i = 0; i < n && i < 12; i++) {
    // sscanf de filas[i] y tres mvprintw en la fila 4 + i
}
refresh();
```
