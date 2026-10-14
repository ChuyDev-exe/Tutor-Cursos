Escribe SIEMPRE en `destino[f][c]`, nunca en `g[f][c]`: si mutas `g` mientras cuentas, las celdas que ya procesaste cambian los vecinos de las que faltan y la simulación deja de ser la de Conway. El andamiaje hace `memcpy(g, destino, sizeof g)` al acabar tu función.

```c
for (int f = 0; f < filas; f++)
    for (int c = 0; c < columnas; c++) {
        int vivos = 0;
        for (int df = -1; df <= 1; df++)
            for (int dc = -1; dc <= 1; dc++) {
                if (df == 0 && dc == 0) continue;
                int vf = f + df, vc = c + dc;
                if (vf < 0 || vf >= filas || vc < 0 || vc >= columnas) continue;
                if (g[vf][vc] == '#') vivos++;
            }
        destino[f][c] = (g[f][c] == '#')
            ? ((vivos == 2 || vivos == 3) ? '#' : '.')
            : (vivos == 3 ? '#' : '.');
    }
```
