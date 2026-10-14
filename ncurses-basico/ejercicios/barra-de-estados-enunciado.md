# Panel de estados de servicios

El andamiaje simula el panel de monitoreo de un servidor: cinco servicios (`cpu`, `ram`, `disco`, `red`, `backup`), cada uno con un semáforo. Tú pintas el panel; el andamiaje después lee el color de cada semáforo con `mvinch` y lo imprime.

Completa la función `pintar_estados`. El andamiaje ya ha hecho `start_color()` y ya ha creado las parejas de color:

| Pareja | Uso |
|---|---|
| `1` | verde → estado `OK` |
| `2` | amarilla → estado `WARN` |
| `3` | roja → estado `CRIT` |

## Qué debe hacer `pintar_estados`

1. Para cada servicio `i` (de 0 a `n - 1`), escribe el nombre en la fila `1 + i`, columna `2`, con `mvprintw`.
2. Enciende el color del estado con `attron(COLOR_PAIR(estados[i]))`.
3. Escribe el bloque `[]` en la fila `1 + i`, columna `20`.
4. Apaga el color con `attroff(COLOR_PAIR(estados[i]))`. **Sin este paso se pintaría el resto de la pantalla.**
5. Al terminar el bucle, muestra los cambios con `refresh()`.

`estados[i]` ya es el número de pareja: 1, 2 o 3. No lo conviertas a nada más.

## Entrada

Una línea con cinco palabras, una por servicio, en este orden: `cpu`, `ram`, `disco`, `red`, `backup`. Cada palabra es `OK`, `WARN` o `CRIT`.

## Salida

El andamiaje imprime cinco líneas, una por servicio, con el número de pareja del color que quedó en la celda del bloque `[]`:

```
cpu=<pareja>
ram=<pareja>
disco=<pareja>
red=<pareja>
backup=<pareja>
```

## Ejemplo

Entrada:

```
OK OK WARN CRIT OK
```

Salida:

```
cpu=1
ram=1
disco=2
red=3
backup=1
```

Edita solo la función marcada con `TODO`.
