#!/usr/bin/env bash
set -euo pipefail

cat > doble.c <<'EOF'
int doble(int a) { return a * 2; }
EOF

cat > main.c <<'EOF'
#include <stdio.h>
int doble(int);
int main(void) { int a; if (scanf("%d", &a) != 1) return 0; printf("%d\n", doble(a)); return 0; }
EOF

gcc -c doble.c -o doble.o
gcc -c main.c -o main.o

# TODO: este nm mira el archivo que define la funcion; hace falta el que la usa
echo "objeto: $(nm doble.o | awk '$3=="_doble"{print $2" "$3}')"

# TODO: la orden de enlace no lleva todas las piezas ni pide el mapa
clang main.o -o prog -Wl,-map,prog.map

echo "ejecutable: $(nm prog | awk '$3=="_doble"{print $2" "$3}')"
echo "mapa: $(awk '$4=="__text"{print $3" "$4; exit}' prog.map)"
echo "programa: $(./prog)"
