# Comparar props

Escribe la función `iguales` que compara dos objetos de props como hace `React.memo`: comparación superficial.

La plantilla ya lee la entrada, convierte cada línea en un objeto de props, llama a tu función y escribe el resultado. Tu trabajo es solo la función.

## Entrada

Dos líneas:

1. Las props anteriores como pares `clave=valor` separados por espacio.
2. Las siguientes props, en el mismo formato. Puede venir vacía.

Los valores no llevan espacios. El orden de las claves puede cambiar de una línea a otra, y eso no es una diferencia.

## Salida

Una sola línea: `si` o `no`.

- `si`: las dos líneas tienen el mismo número de claves y, para cada clave de la primera, el valor es igual con `Object.is`.
- `no`: falta una clave, sobra una, o algún valor cambió.

No imprimas nada más.

## Ejemplo

Entrada:
```
a=1 b=2
b=2 a=1
```

Salida: `si`

Entrada:
```
a=1 b=2
a=1 b=3
```

Salida: `no`
