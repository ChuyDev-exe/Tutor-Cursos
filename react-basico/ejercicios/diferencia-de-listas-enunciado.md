# Diferencia de listas

Escribe la función `diferencia` que compara dos listas de keys, como haría la conciliación de React con una lista.

La plantilla ya incluye el mini React del curso, lee la entrada, llama a tu función y escribe el resultado. Tu trabajo es solo la función.

## Entrada

Dos líneas:

1. Las keys de la lista anterior, separadas por espacio. Puede venir vacía.
2. Las keys de la lista siguiente, también separadas por espacio. Puede venir vacía.

Las keys de cada lista no se repiten.

## Salida

Exactamente tres líneas, en este orden:

- `añadidos: a b c` — las keys de la siguiente que no estaban en la anterior, en orden de la siguiente. Si no hay, solo `añadidos:`.
- `quitados: x y` — las keys de la anterior que ya no están en la siguiente, en orden de la anterior. Si no hay, solo `quitados:`.
- `movidos: m n` — las keys que están en las dos listas pero en posición distinta, en orden de la siguiente. Si no hay, solo `movidos:`.

No imprimas nada más.

## Ejemplo

Entrada:
```
a b c
c a x
```

Salida:
```
añadidos: x
quitados: b
movidos: c a
```
