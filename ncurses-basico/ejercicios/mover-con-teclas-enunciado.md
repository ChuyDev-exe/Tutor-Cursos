# Mover con teclas

Completa la función `jugar` del script. Una `@` empieza en la fila 0, columna 0. Cada tecla la mueve una celda. El área mide 10 filas (`ALTO`) por 20 columnas (`ANCHO`).

Edita solo la función marcada con `TODO`.

## Teclas

| Tecla | Movimiento |
|---|---|
| `w` | una fila arriba |
| `s` | una fila abajo |
| `a` | una columna a la izquierda |
| `d` | una columna a la derecha |
| `q` | termina |

Cualquier otra tecla (por ejemplo, el salto de línea) no mueve nada. La `@` nunca sale del área: si ya está en el borde, se queda donde está. Cuando no quedan teclas, `getch()` devuelve `ERR` y el juego también termina.

En cada movimiento, borra la `@` de su celda antigua. En pantalla debe quedar **una sola** `@`.

## Entrada
Una línea con las teclas pulsadas, por ejemplo `ddsq`.

## Salida
El andamiaje imprime la posición final, el carácter de esa celda y cuántas `@` hay en pantalla:

```
y=<fila> x=<columna>
celda=@
arrobas=1
```

## Ejemplo
Entrada: `ddsq`  →  Salida:

```
y=1 x=2
celda=@
arrobas=1
```
