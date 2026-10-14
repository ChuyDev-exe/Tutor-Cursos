# Pasos de compilación

El script convierte `doble.c` en un ejecutable pasándolo por los cuatro pasos de la compilación, uno a uno. Cada paso deja su archivo y el script comprueba el resultado imprimiendo una línea.

Hay cuatro líneas marcadas con `TODO`. Cada una tiene un comando que usa la opción equivocada: cámbiala por la que corresponde al paso (preprocesar, compilar a ensamblador, ensamblar, enlazar).

## Entrada

Una línea con un entero.

## Salida

Cuatro líneas, en este orden exacto:

```
preproceso: ok
ensamblador: _doble:
objeto: T _doble
ejecutable: N
```

Donde `N` es el doble del número leído. Nada más.

## Ejemplo

Entrada: `4`

Salida:

```
preproceso: ok
ensamblador: _doble:
objeto: T _doble
ejecutable: 8
```
