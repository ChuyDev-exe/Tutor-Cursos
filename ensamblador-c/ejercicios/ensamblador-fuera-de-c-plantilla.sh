#!/usr/bin/env bash
set -euo pipefail

cat > main.c <<'C'
#include <stdio.h>
int suma(int, int);
int main(void) { int a, b; if (scanf("%d %d", &a, &b) != 2) return 0; printf("suma=%d\n", suma(a, b)); return 0; }
C

cat > suma.s <<'ASM'
.globl _suma
_suma:
    // TODO: suma x0 y x1 dejando el resultado en x0
    ret
ASM

gcc -c suma.s -o suma.o
gcc -c main.c -o main.o
clang main.o suma.o -o prog
./prog
