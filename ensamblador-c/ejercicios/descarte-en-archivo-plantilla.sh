#!/usr/bin/env bash
set -euo pipefail

caso=""
read -r caso || true

cat > piezas.s <<'ASM'
.subsections_via_symbols
.text
.globl _usada
_usada:
    mov w0, #1
    ret
.globl _hueca
_hueca:
    mov w0, #2
    ret
ASM

case "$caso" in
  hueca) llamadas="bl _hueca" ;;
  ambas) llamadas=$'bl _usada\n    bl _hueca' ;;
  *)     llamadas="bl _usada" ;;
esac

cat > main.s <<ASM
.text
.globl _main
_main:
    $llamadas
    mov w0, #0
    ret
ASM

as piezas.s -o piezas.o
as main.s -o main.o

# TODO: la orden de enlace necesita las dos piezas
clang main.o -o prog1
echo "sin descarte: $(nm prog1 | awk '$2=="T"{print $3}' | grep -E '_(usada|hueca)' | LC_ALL=C sort | xargs)"

# TODO: vuelve a enlazar dejando que el enlazador tire el codigo muerto
clang main.o piezas.o -o prog2
echo "con descarte: $(nm prog2 | awk '$2=="T"{print $3}' | grep -E '_(usada|hueca)' | LC_ALL=C sort | xargs)"
