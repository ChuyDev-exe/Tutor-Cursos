# Contador con reducer

Escribe la función `reducer` que calcula el nuevo valor de un contador a partir de una acción.

La plantilla ya incluye el código que lee la entrada, parsea las acciones y las aplica en orden. Tu trabajo es solo el reducer.

## Entrada

Varias líneas:

1. La primera es el valor inicial del contador.
2. Las siguientes son acciones, una por línea:
   - `incrementar`
   - `restar`
   - `poner N` (donde `N` es un número, puede ser negativo)

## Salida

Una sola línea: el valor final del contador.

Una acción desconocida no cambia el valor.

## Ejemplo

Entrada:
```
0
incrementar
incrementar
```

Salida: `2`

Entrada:
```
0
poner -3
incrementar
```

Salida: `-2`
