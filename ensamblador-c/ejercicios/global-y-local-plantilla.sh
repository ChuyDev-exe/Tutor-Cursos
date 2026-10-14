#!/usr/bin/env bash
set -euo pipefail

caso=""
read -r caso || true

cat > pieza.s <<'ASM'
.text
.globl _saluda
_saluda:
    mov w0, #1
    ret
_interna:
    mov w0, #2
    ret
ASM

cat > main.s <<'ASM'
.text
.globl _main
_main:
    bl _saluda
    mov w0, #0
    ret
ASM

as pieza.s -o pieza.o
as main.s -o main.o

# TODO: lista las dos funciones del .o, la global y la local
objeto=$(nm pieza.o | awk '$2=="T"{print $2" "$3}' | LC_ALL=C sort | xargs)

clang main.o pieza.o -o prog

# TODO: lista los simbolos de texto del ejecutable, sin _main
enlace=$(nm prog | awk '$2=="T"||$2=="t"{print $2" "$3}' | xargs)

case "$caso" in
  objeto) echo "objeto: $objeto" ;;
  enlace) echo "enlace: $enlace" ;;
  *) echo "objeto: $objeto"; echo "enlace: $enlace" ;;
esac
