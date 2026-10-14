# Mapa de enlace

El script compila una función en `doble.c` y un `main` que la usa, y luego sigue a ese símbolo por todo el proceso: primero en su archivo objeto, después en el ejecutable y por último en el mapa de enlace.

Hay tres líneas marcadas con `TODO`: una mira la tabla de símbolos del archivo equivocado, otra no incluye todas las piezas del enlace y la tercera no pide el mapa.

## Entrada

Una línea con un entero.

## Salida

Cuatro líneas, en este orden exacto:

```
objeto: U _doble
ejecutable: T _doble
mapa: __TEXT __text
programa: N
```

Donde `N` es el doble del número leído. Nada más.

## Ejemplo

Entrada: `4`

Salida:

```
objeto: U _doble
ejecutable: T _doble
mapa: __TEXT __text
programa: 8
```
