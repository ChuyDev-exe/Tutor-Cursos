#!/usr/bin/env bash
set -euo pipefail

# Completa las recetas del Makefile (con TAB) y el cuerpo de suma en sum.c.
cat > Makefile <<'MK'
prog: main.o sum.o
	# TODO: enlaza main.o y sum.o en prog con clang

main.o: main.c
	# TODO: compila main.c con gcc -c

sum.o: sum.c
	# TODO: compila sum.c con gcc -c
MK

cat > sum.c <<'C'
int suma(int a, int b) {
    // TODO: devuelve la suma de a y b
    return 0;
}
C

cat > main.c <<'C'
#include <stdio.h>
int suma(int, int);
int main(void) { int a, b; if (scanf("%d %d", &a, &b) != 2) return 0; printf("r=%d\n", suma(a, b)); return 0; }
C

make -s
./prog
