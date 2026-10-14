#!/usr/bin/env bash
set -euo pipefail

cat > limpiar.s <<'ASM'
.text
.globl _limpiar
_limpiar:
    # TODO: recorre [x0, x1) poniendo cada byte a cero (pista 1 y 2)
    ret
ASM

cat > main.c <<'EOF'
#include <stdio.h>
unsigned char zona[64];
extern void limpiar(void *, void *);
int main(void){
    int n, i, antes = 0, despues = 0;
    if (scanf("%d", &n) != 1) return 0;
    if (n < 0) n = 0;
    if (n > 64) n = 64;
    for (i = 0; i < n; i++) zona[i] = 0x5A;
    for (i = 0; i < n; i++) if (zona[i]) antes++;
    limpiar(zona, zona + n);
    for (i = 0; i < n; i++) if (zona[i]) despues++;
    printf("no cero antes: %d\n", antes);
    printf("no cero despues: %d\n", despues);
    return 0;
}
EOF

gcc -c limpiar.s -o limpiar.o
gcc -c main.c -o main.o
clang main.o limpiar.o -o prog
./prog
