# Juego de la Vida (Conway)

Estás implementando el clásico de John Conway: una rejilla de células que vivas o muertas evolucionan generación tras generación con una sola regla. El andamiaje carga `inicial.txt` (6 filas de 12 caracteres, `#` = viva, `.` = muerta) en la matriz `g` y te pasa también la matriz `destino`, vacía. La pantalla mide 6 filas por 14 columnas y dibuja `O` por cada viva y `.` por cada muerta.

Patrón inicial:

```
............
....#.......
...###......
............
....#.#.....
............
```

## Las reglas de Conway

Para cada celda se cuentan sus **8 vecinas** (las celdas alrededor). Las que caen fuera de la matriz cuentan como muertas: **nunca leas fuera de `0 .. filas-1` y `0 .. columnas-1`**.

| Estado actual | Vecinos vivos | Nuevo estado |
|---|---|---|
| viva (`#`) | 2 o 3 | sigue viva |
| viva (`#`) | cualquier otro | muere |
| muerta (`.`) | exactamente 3 | nace |
| muerta (`.`) | cualquier otro | sigue muerta |

## Qué debe hacer `evolucionar`

1. Para cada celda `(f, c)`: cuenta sus 8 vecinas con dos bucles `df` y `dc` de -1 a 1, saltando la central (`df == 0 && dc == 0`) y las que se salen de la matriz.
2. Escribe **solo en `destino`**: `destino[f][c] = '#'` si (estaba viva y tiene 2 o 3 vecinos vivos) o (estaba muerta y tiene exactamente 3); si no, `destino[f][c] = '.'`.

**Regla de oro: nunca mutar `g` mientras cuentas vecinos.** Todas las cuentas se hacen sobre el estado actual; la generación nueva se copia después con `memcpy(g, destino, sizeof g)` (eso lo hace el andamiaje). Tu función calcula exactamente UNA generación.

## Entrada

Teclas: `n` (o Enter) aplica una generación y repinta; `q` o el fin de la entrada terminan. Cualquier otra tecla se ignora.

## Salida

El andamiaje lee la pantalla (comprobando así que dibujaste la evolución) e imprime:

```
generaciones=<cuántas se aplicaron>
fila=<12 caracteres de la fila 0>
…
fila=<12 caracteres de la fila 5>
```

## Ejemplo

Entrada: `n`  →  Salida:

```
generaciones=1
fila=............
fila=...OOO......
fila=...OOO......
fila=...O........
fila=............
fila=............
```

Edita solo la función marcada con `TODO`.
