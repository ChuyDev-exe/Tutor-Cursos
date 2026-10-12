#!/usr/bin/env bash
set -euo pipefail

# Completa el script: el cuerpo de _suma y la orden de enlace.
cat > suma.s <<'ASM'
.globl _suma
_suma:
    # TODO: devuelve en x0 la suma de los argumentos x0 y x1
    ret
ASM

gcc -c suma.s -o suma.o
ar rcs libsuma.a suma.o

cat > main.c <<'C'
#include <stdio.h>
int suma(int, int);
int main(void) { int a, b; if (scanf("%d %d", &a, &b) != 2) return 0; printf("suma=%d\n", suma(a, b)); return 0; }
C

gcc -c main.c -o main.o
# TODO: enlaza main.o con la biblioteca del directorio actual (pistas 2 y 3)
clang main.o -o prog
./prog
