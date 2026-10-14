Para el giro de 180°: convierte la tecla en la dirección nueva (`ndy`, `ndx`) y compárala con la actual. Si `ndy == -diry && ndx == -dirx`, `continue` sin mover. Guarda una bandera `primera` para saltarte esa comprobación en la primera tecla de la partida: así `a` como primera tecla sí fija la dirección izquierda.

```c
int ndy = diry, ndx = dirx, gira = 0;
if (t == 'w' || t == KEY_UP)    { ndy = -1; ndx = 0; gira = 1; }
if (t == 's' || t == KEY_DOWN)  { ndy = 1;  ndx = 0; gira = 1; }
if (t == 'a' || t == KEY_LEFT)  { ndy = 0;  ndx = -1; gira = 1; }
if (t == 'd' || t == KEY_RIGHT) { ndy = 0;  ndx = 1; gira = 1; }
if (!gira) continue;
if (!primera && ndy == -diry && ndx == -dirx) continue;
diry = ndy; dirx = ndx; primera = 0;
```
