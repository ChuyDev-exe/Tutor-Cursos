#!/usr/bin/env bash
set -euo pipefail

cat > datos.c <<'EOF'
#include <stdio.h>
int inicial = 42;
int sin_inicializar;
const char mensaje[] = "hola";
int main(void){ printf("%d\n", inicial + sin_inicializar + mensaje[0]); return 0; }
EOF

gcc -c datos.c -o datos.o
clang datos.o -o prog

# TODO: extrae la seccion de un simbolo con nm -m; aqui solo se imprime el tipo
seccion(){ nm -m prog | awk -v s="$1" '$4==s {print $3}'; }

caso=""
read -r caso || true

case "$caso" in
  data)
    echo "inicializado: $(seccion _inicial)"
    ;;
  const)
    echo "constante: $(seccion _mensaje)"
    ;;
  bss)
    echo "sin inicializar: $(seccion _sin_inicializar)"
    # TODO: imprime nombre y tipo de la seccion marcada como BSS
    echo "bss: $(objdump -h prog | awk '$5=="BSS"{print $5}')"
    ;;
  *)
    echo "inicializado: $(seccion _inicial)"
    echo "constante: $(seccion _mensaje)"
    echo "sin inicializar: $(seccion _sin_inicializar)"
    echo "bss: $(objdump -h prog | awk '$5=="BSS"{print $2" "$5}')"
    ;;
esac
