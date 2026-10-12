#!/usr/bin/env bash
set -euo pipefail

cat > doble.s <<'ASM'
.globl _main
_main:
    sub sp, sp, #48
    stp x29, x30, [sp, #32]
    add x29, sp, #32
    // TODO: calcula &n, déjala en [sp+0] y llama a _scanf con el formato "%d" en x0
    // TODO: comprueba que w0 vale 1; si no vale 1, sal a fin
    // TODO: lee n, duplica el valor y llama a _printf con "doble=%d"
fin:
    mov w0, #0
    ldp x29, x30, [sp, #32]
    add sp, sp, #48
    ret

.data
fmt1: .asciz "%d"
fmt2: .asciz "doble=%d\n"
ASM

as doble.s -o doble.o
clang doble.o -o doble
./doble
