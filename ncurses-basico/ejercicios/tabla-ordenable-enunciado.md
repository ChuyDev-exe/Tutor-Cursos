# Tabla ordenable (inventario)

Estás construyendo la pantalla de un gestor de inventario, como la vista de tabla de cualquier ERP: 8 productos con nombre, cantidad y precio, cargados de `productos.txt` por el andamiaje y guardados en un array de structs `Producto`. Una cabecera explica las teclas y el alumno puede reordenar la tabla entera al vuelo.

La pantalla mide 14 filas por 40 columnas. La cabecera va en la fila 0 y el producto `i` se dibuja en la fila `2 + i`.

## Qué debe hacer tu código

1. `comparador` (`comparar`): es el comparador que recibe `qsort`. Convierte los dos `void *` a `const Producto *` y compara según la variable global `campo_orden`:
   - `campo_orden == 1`: compara los nombres con `strcmp` (que ya devuelve `<0`, `0` o `>0`);
   - `campo_orden == 2`: compara `cantidad` (menor → negativo, mayor → positivo, igual → 0);
   - `campo_orden == 3`: compara `precio` de la misma forma.
2. `gestionar`, en un bucle `for (;;)`, primero dibuja y después lee la tecla:
   - cabecera: `mvprintw(0, 2, "n=nombre c=cantidad p=precio")`;
   - tabla: para `i` de 0 a `n-1`, `mvprintw(2 + i, 2, "%-10s %3d %3d", p[i].nombre, p[i].cantidad, p[i].precio)`;
   - `refresh();`
   - `getch()`: `n` → `campo_orden = 1`, `c` → `2`, `p` → `3`; **solo `q` o `ERR` terminan con `break`**; cualquier otra tecla se ignora y vuelve a repintar. Ojo: justo después de `resizeterm`, la primera `getch()` entrega `KEY_RESIZE` (410); no es `ERR` y no debe cerrar la tabla.
3. Si la tecla era `n`, `c` o `p`: `qsort(p, n, sizeof(Producto), comparar);` y, tras `werase(stdscr)`, vuelve al inicio del bucle para repintar la tabla entera.

**Regla de oro:** `qsort` ordena el array en el sitio (in-place) y borra el orden anterior. Por eso la tabla se repinta entera tras cada orden: nunca queda una fila vieja en pantalla.

## Entrada

Teclas pulsadas, por ejemplo `p`. Cada tecla reordena y repinta; `q` o el fin de la entrada terminan.

## Salida

El andamiaje vuelve a leer las filas 2 a 9 de la pantalla (es decir, comprueba que dibujaste la tabla ordenada) e imprime una línea por producto:

```
fila=<nombre>|<cantidad>|<precio>
```

## Ejemplo

Entrada: `p`  →  Salida:

```
fila=naranja|15|1
fila=platano|7|2
fila=manzana|12|3
fila=kiwi|30|4
fila=fresa|9|5
fila=pera|5|6
fila=uvas|20|8
fila=melon|2|9
```

Edita solo las funciones marcadas con `TODO`.
