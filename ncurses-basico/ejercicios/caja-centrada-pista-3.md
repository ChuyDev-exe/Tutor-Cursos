Último tramo:

```c
WINDOW *v = newwin(5, ancho, y, x);
box(v, 0, 0);
mvwprintw(v, 0, 2, titulo);
mvwprintw(v, 2, 2, mensaje);
wrefresh(v);
getch();
delwin(v);
```

La ventana se dibuja con sus propias coordenadas: la fila 0 de `v` es el borde de arriba.
