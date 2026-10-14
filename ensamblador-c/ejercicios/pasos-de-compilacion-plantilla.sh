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

# TODO paso 1: esta opcion ensambla; la que falta solo preprocesa doble.c a doble.i
gcc -c doble.c -o doble.i
grep -q "int doble" doble.i && echo "preproceso: ok"

# TODO paso 2: esta opcion ensambla; la que falta se detiene y escribe doble.s
gcc -c doble.c -o doble.s
grep -o "^_doble:" doble.s | head -1 | sed 's/^/ensamblador: /'

gcc -c main.c -o main.o

# TODO paso 3: esta opcion solo preprocesa; aqui hace falta dejar doble.o
gcc -E -P doble.c -o doble.o
echo "objeto: $(nm doble.o | awk '$3=="_doble"{print $2" "$3}')"

# TODO paso 4: falta una pieza en la orden de enlace
clang main.o -o prog

echo "ejecutable: $(./prog)"
