```bash
#!/usr/bin/env bash
set -euo pipefail

cat > Makefile <<'MK'
prog: main.o suma.o
	clang main.o suma.o -o prog

main.o: main.c
	gcc -c main.c -o main.o

suma.o: suma.c
	gcc -c suma.c -o suma.o

simbolos: suma.o
	nm suma.o | grep ' T _suma'
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
```

La idea: `simbolos` no construye un archivo; es una etiqueta con una receta de inspección. `nm suma.o` lista los símbolos y `grep ' T _suma'` deja solo la línea de la función definida en texto.
