# Reordenar sin mutar

Escribe la función `aplicar` que aplica acciones de lista (añadir, quitar, subir, bajar) sin modificar la lista original.

La plantilla ya lee la entrada, parsea las acciones, llama a tu función y escribe el resultado. Tu trabajo es solo la función.

## Entrada

Dos tipos de línea:

1. Primera línea: los ids iniciales separados por espacio. Puede venir vacía.
2. Las siguientes son acciones, una por línea:
   - `añadir id` — si el id ya estaba, la lista no cambia. Si no, se añade al final.
   - `quitar id` — se elimina de la lista. Si no estaba, no cambia.
   - `subir id` — intercambia el id con el anterior. Si es el primero, no cambia.
   - `bajar id` — intercambia el id con el siguiente. Si es el último, no cambia.

Tu función debe devolver siempre un array: nuevo o el mismo, nunca `undefined`.

## Salida

Exactamente dos líneas:

- `original: a b c` — la lista inicial, intacta. Si está vacía, solo `original:`.
- `lista: a c b` — el resultado final de aplicar las acciones en orden. Si está vacía, solo `lista:`.

La primera línea se escribe después de aplicar las acciones. Si tu función modifica el array original, esa línea cambia y las pruebas fallan.

No imprimas nada más.

## Ejemplo

Entrada:
```
a b
añadir c
bajar a
```

Salida:
```
original: a b
lista: b a c
```
