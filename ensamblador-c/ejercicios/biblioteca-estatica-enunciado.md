# Biblioteca estatica

El script crea una biblioteca estática (un archivo `.a` que junta uno o varios `.o`) y enlaza `main.c` contra ella. El `main` en C ya está escrito; te faltan dos piezas.

Completa el cuerpo de la función `_suma` en `suma.s` y la orden de enlace. En macOS la función `suma` del C se llama `_suma` en ensamblador. Los argumentos llegan en los registros `x0` y `x1`, y el resultado se devuelve en `x0`.

## Entrada

Una línea con dos números enteros, separados por un espacio.

## Salida

Una línea con el texto `suma=` y el resultado de sumar los dos números. Nada más.

## Ejemplo

Entrada: `3 4`  →  Salida: `suma=7`
