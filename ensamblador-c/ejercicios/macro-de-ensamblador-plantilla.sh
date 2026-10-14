#!/usr/bin/env bash
set -euo pipefail

cat > suma.S <<'ASM'
#define OPER add
.text
.globl _suma
_suma:
    OPER x0, x0, x1
    ret
ASM

cat > main.c <<'EOF'
#include <stdio.h>
int suma(int, int);
int main(void){ int a, b; if (scanf("%d %d", &a, &b) != 2) return 0; printf("%d\n", suma(a, b)); return 0; }
EOF

# TODO paso 1: esta opcion ensambla; la que falta deja el texto preprocesado en suma.i
gcc -c suma.S -o suma.i
grep -q "add x0, x0, x1" suma.i && echo "preproceso: add x0, x0, x1"

gcc -c main.c -o main.o

# TODO paso 2: esta opcion solo preprocesa; aqui hace falta dejar suma.o
gcc -E -P suma.S -o suma.o
echo "objeto: $(nm suma.o | awk '$3=="_suma"{print $2" "$3}')"

# TODO paso 3: falta una pieza en la orden de enlace
clang main.o -o prog

echo "ejecutable: $(./prog)"
