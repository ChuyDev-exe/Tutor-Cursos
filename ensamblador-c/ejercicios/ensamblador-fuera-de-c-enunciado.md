# Ensamblador fuera de C

Escribe un script bash que mezcla C y ensamblador en ficheros separados. El script crea un `main.c` que lee dos enteros y llama a una función `suma` declarada en C, y un `suma.s` que define esa función en ensamblador ARM64. Después compila cada archivo por separado, enlaza los dos objetos y ejecuta el programa.

## Entrada
Una línea con dos enteros separados por un espacio.

## Salida
Una línea con el texto `suma=` seguido de la suma y un salto de línea. No se imprime nada más.

## Ejemplo
Entrada: `3 4`  →  Salida: `suma=7`
