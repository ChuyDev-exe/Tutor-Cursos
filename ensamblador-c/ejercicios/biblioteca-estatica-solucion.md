```bash
#!/usr/bin/env bash
set -euo pipefail

cat > suma.s <<'ASM'
.globl _suma
_suma:
    add x0, x0, x1
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
clang main.o -L. -lsuma -o prog
./prog
```

La idea: `ar rcs libsuma.a suma.o` empaqueta el `.o` en una biblioteca estática. Luego `clang main.o -L. -lsuma` busca `libsuma.a` en el directorio actual y enlaza su contenido. `_suma` suma los dos argumentos y devuelve el resultado en `x0`.
