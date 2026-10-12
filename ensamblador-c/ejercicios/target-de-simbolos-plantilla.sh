#!/usr/bin/env bash
set -euo pipefail

# Completa la receta del objetivo simbolos del Makefile (con TAB).
cat > Makefile <<'MK'
prog: main.o suma.o
	clang main.o suma.o -o prog

main.o: main.c
	gcc -c main.c -o main.o

suma.o: suma.c
	gcc -c suma.c -o suma.o

simbolos: suma.o
	# TODO: muestra el símbolo _suma definido en suma.o
MK

cat > suma.c <<'C'
int suma(int a, int b) { return a + b; }
C

cat > main.c <<'C'
#include <stdio.h>
int suma(int, int);
int main(void) { int a, b; if (scanf("%d %d", &a, &b) != 2) return 0; printf("r=%d\n", suma(a, b)); return 0; }
C

make -s
./prog
make -s simbolos
