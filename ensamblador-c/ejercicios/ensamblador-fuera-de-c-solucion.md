```bash
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
    add x0, x0, x1
    ret
ASM

gcc -c suma.s -o suma.o
gcc -c main.c -o main.o
clang main.o suma.o -o prog
./prog
```

En Mach-O la función C `suma` se escribe `_suma`. Los argumentos llegan en `x0` y `x1`, y el resultado se devuelve en `x0`. El build son tres pasos: dos `gcc -c` que producen los `.o` y un `clang` que los enlaza.
