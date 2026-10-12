```bash
#!/usr/bin/env bash
set -euo pipefail

cat > Makefile <<'MK'
prog: main.o sum.o
	clang main.o sum.o -o prog

main.o: main.c
	gcc -c main.c -o main.o

sum.o: sum.c
	gcc -c sum.c -o sum.o
MK

cat > sum.c <<'C'
int suma(int a, int b) { return a + b; }
C

cat > main.c <<'C'
#include <stdio.h>
int suma(int, int);
int main(void) { int a, b; if (scanf("%d %d", &a, &b) != 2) return 0; printf("r=%d\n", suma(a, b)); return 0; }
C

make -s
./prog
```

La idea: cada receta empieza con un tabulador. `make -s` construye `prog` sin imprimir los comandos, y después `./prog` lee los dos números y muestra `r=` con la suma.
