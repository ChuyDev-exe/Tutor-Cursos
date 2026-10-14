#!/usr/bin/env bash
set -euo pipefail

cat > ayuda.c <<'EOF'
int helper(void) { return 5; }
EOF

cat > con.c <<'EOF'
#include <stdio.h>
int helper(void);
int main(void){ printf("hola\n"); return helper(); }
EOF

cat > sin.c <<'EOF'
#include <stdio.h>
int main(void){ printf("hola\n"); return 0; }
EOF

gcc -c ayuda.c -o ayuda.o
ar rcs libayuda.a ayuda.o

caso=""
read -r caso || true

case "$caso" in
  llama)
    gcc -c con.c -o con.o
    # TODO: la biblioteca esta en este directorio y se pide con -L y -l
    clang con.o -o prog
    ;;
  sin)
    gcc -c sin.c -o sin.o
    # TODO: aqui se enlaza contra la biblioteca, no contra el .o suelto
    clang sin.o ayuda.o -o prog
    ;;
  fuerza)
    gcc -c sin.c -o sin.o
    # TODO: nadie llama a helper; arrastra el miembro de la biblioteca igualmente
    clang sin.o -L. -layuda -o prog
    ;;
esac

if nm prog | grep -q " _helper$"; then echo "helper: si"; else echo "helper: no"; fi
