# Estado con dos campos

Escribe la función `reducer` de un estado con dos campos: `contador` y `visible`.

La plantilla ya lee la entrada, parsea las acciones, las aplica en orden y escribe el resultado. Tu trabajo es solo el reducer.

## Entrada

Varias líneas:

1. La primera es el valor inicial del contador.
2. Las siguientes son acciones, una por línea:
   - `subir`
   - `bajar`
   - `fijar N` (donde `N` es un número, puede ser negativo)
   - `alternar`

`visible` empieza en `true`.

## Salida

Una sola línea con dos valores separados por un espacio: el contador y `visible`.

Ejemplo: `2 false`

Una acción desconocida no cambia nada.

## Ejemplo

Entrada:
```
0
subir
subir
alternar
```

Salida: `2 false`

Entrada:
```
5
bajar
fijar 10
```

Salida: `10 true`
