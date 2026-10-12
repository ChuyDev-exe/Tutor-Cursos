# Makefile basico

El script escribe un Makefile, los dos ficheros C y ejecuta `make -s`. Te toca completar las recetas del Makefile y el cuerpo de `suma` en `sum.c`.

El Makefile ya tiene las tres reglas con sus dependencias: `prog` depende de `main.o` y `sum.o`, `main.o` depende de `main.c` y `sum.o` depende de `sum.c`. Cada receta necesita un **tabulador** al principio; con espacios, make se detiene con `missing separator`.

## Entrada

Una línea con dos números enteros, separados por un espacio.

## Salida

Una línea con `r=` y el resultado de sumar los dos números. Nada más: el script usa `make -s` para que make no imprima los comandos.

## Ejemplo

Entrada: `3 4`  →  Salida: `r=7`
