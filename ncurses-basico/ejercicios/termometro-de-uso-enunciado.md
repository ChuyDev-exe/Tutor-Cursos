# Termometro de uso

Tienes que pintar un medidor de uso estilo `htop`: una barra de 20 celdas que se llena según el porcentaje y cambia de color como un semáforo.

Completa la función `pintar_termometro`. El andamiaje ya ha llamado a `start_color()` y ya ha creado estas parejas:

| Pareja | Color | Cuándo se usa |
|---|---|---|
| `1` | verde | porcentaje menor de 60 |
| `2` | amarilla | de 60 a 84 (incluidos) |
| `3` | roja | 85 o más |

## Qué debe hacer `pintar_termometro`

1. Calcula las celdas llenas: `relleno = porcentaje / 5` (división entera, hacia abajo). 100 da 20; 59 da 11. Entre 0 y 20.
2. Elige la pareja según la tabla de arriba.
3. Recorre las 20 celdas de la barra: fila `3`, columnas `1` a `20`.
4. Si la celda `i` es de las llenas (`i < relleno`), escribe `#` con el color encendido: `attron(COLOR_PAIR(pareja))` … escribe … `attroff(COLOR_PAIR(pareja))`.
5. Si no, escribe `-` **sin color**.
6. Muestra los cambios con `refresh()`.

## Entrada

Una línea con un entero (el porcentaje), por ejemplo `40`.

## Salida

El andamiaje lee la barra de la pantalla y imprime tres líneas:

```
relleno=<celdas llenas>
color=<verde|amarillo|rojo|ninguno>
barra=<las 20 celdas como texto>
```

Si `relleno` es 0 no hay ninguna celda de color, y el andamiaje imprime `color=ninguno`.

## Ejemplo

Entrada: `40`  →  Salida:

```
relleno=8
color=verde
barra=########----------------
```

Edita solo la función marcada con `TODO`.
