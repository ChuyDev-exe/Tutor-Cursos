# Macro de ensamblador

Este script escribe un archivo de ensamblador `suma.S` (con mayúscula) que usa una macro del preprocesador: la instrucción real está en `#define OPER add`, y dentro de `_suma` solo aparece `OPER`.

Tienes tres líneas marcadas con `TODO`. Cada una usa la opción equivocada del paso que le toca.

## Entrada

Una línea con dos enteros separados por un espacio.

## Salida

Tres líneas, en este orden exacto:

```
preproceso: add x0, x0, x1
objeto: T _suma
ejecutable: N
```

Donde `N` es la suma de los dos números leídos. Nada más.

## Ejemplo

Entrada: `3 4`

Salida:

```
preproceso: add x0, x0, x1
objeto: T _suma
ejecutable: 7
```
