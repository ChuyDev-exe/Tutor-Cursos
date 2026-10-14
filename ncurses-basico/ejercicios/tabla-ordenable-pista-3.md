Esta estructura evita duplicar el dibujo: dibujas, haces `refresh`, lees la tecla; solo si es `n`, `c` o `p` cambias `campo_orden`, haces `qsort` y `werase(stdscr)` para que el bucle vuelva a dibujar desde cero; solo `q` o `ERR` hacen `break` (cualquier otra tecla, como el `KEY_RESIZE` de la primera vuelta, se ignora).

```c
for (;;) {
    mvprintw(0, 2, "n=nombre c=cantidad p=precio");
    for (int i = 0; i < n; i++)
        mvprintw(2 + i, 2, "%-10s %3d %3d", p[i].nombre, p[i].cantidad, p[i].precio);
    refresh();
    int tecla = getch();
    if (tecla == 'n' || tecla == 'c' || tecla == 'p') {
        campo_orden = (tecla == 'n') ? 1 : (tecla == 'c') ? 2 : 3;
        qsort(p, n, sizeof(Producto), comparar);
        werase(stdscr);
    } else if (tecla == 'q' || tecla == ERR) {
        break;
    }
}
```
