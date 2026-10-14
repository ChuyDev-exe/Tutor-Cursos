# Tabla de inventario con bordes

Vas a dibujar una tabla de inventario en la terminal, como una hoja de cálculo hecha con líneas: título, cabecera, separador y laterales con los caracteres ACS.

El andamiaje dimensiona la pantalla a 20 filas por 60 columnas y te pasa las filas de datos con el formato `nombre,cantidad,precio`.

## Qué debe hacer `dibujar_tabla`

Geometría fija (fila siempre antes que columna):

| Elemento | Posición |
|---|---|
| Título `Inventario` | fila 0, columna 2 |
| Cabecera fila 2 | `Nombre` en x=2, `Cant.` en x=16, `Precio` en x=24 |
| Separador horizontal | `mvhline(3, 1, ACS_HLINE, 32)` |
| Laterales | `mvvline(1, 0, ACS_VLINE, 3 + n)` y `mvvline(1, 33, ACS_VLINE, 3 + n)` |
| Datos | desde la fila 4: nombre en x=2, cantidad en x=16, precio en x=24 |

Pasos:

1. Escribe el título y la cabecera con `mvprintw`.
2. Dibuja la línea horizontal con `mvhline` y los dos laterales con `mvvline`. Usa los caracteres `ACS_HLINE` y `ACS_VLINE`, no guiones o barras literales.
3. Separa cada `filas[i]` en sus tres campos (`sscanf` con `%[^,]` o `strtok` con `,`).
4. Escribe los campos de cada fila de datos en la fila `4 + i`. Como máximo dibuja **12 filas** (filas 4 a 15).
5. Muestra los cambios con `refresh()`.

## Entrada

Primero un número `n`, y después `n` líneas con el formato `nombre,cantidad,precio`:

```
2
pan,5,2
leche,3,4
```

## Salida

El andamiaje vuelve a leer la pantalla e imprime: la cabecera en tres columnas unidas con `|`, una línea `fila=` por cada fila de datos, y si el separador horizontal está en su sitio:

```
cab=Nombre|Cant.|Precio
fila=<nombre>|<cantidad>|<precio>
…
separador=<si|no>
```

Los textos se leen de la pantalla y se recortan los espacios de la derecha.

## Ejemplo

Entrada:

```
2
pan,5,2
leche,3,4
```

Salida:

```
cab=Nombre|Cant.|Precio
fila=pan|5|2
fila=leche|3|4
separador=si
```

Edita solo la función marcada con `TODO`.
