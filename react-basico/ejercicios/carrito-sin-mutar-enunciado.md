# Carrito sin mutar

Escribe la función `carritoReducer` que añade o quita productos de un carrito sin modificar el array original.

La plantilla ya lee la entrada, crea el array inicial, parsea las acciones, las aplica en orden y escribe el resultado en formato JSON. Tu trabajo es solo el reducer.

## Entrada

Varias líneas:

1. La primera es la lista inicial de productos, separada por comas. Si está vacía, el carrito empieza vacío.
2. Las siguientes son acciones, una por línea:
   - `añadir X` (donde `X` es el producto)
   - `quitar X`

Reglas:

- `añadir X`: si `X` ya está en el carrito, no cambia nada. Si no está, se añade al final.
- `quitar X`: elimina todas las apariciones de `X`. Si no estaba, no cambia nada.

## Salida

Una sola línea con el carrito final en formato JSON, por ejemplo:

`["leer","comprar"]`

Si queda vacío, la salida es `[]`. No imprimas nada más.

## Ejemplo

Entrada:
```
a,b,c
quitar b
```

Salida: `["a","c"]`
