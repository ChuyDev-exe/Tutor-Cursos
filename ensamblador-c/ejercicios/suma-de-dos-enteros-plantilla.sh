#!/usr/bin/env bash
set -euo pipefail

cat > suma.s <<'ASM'
.globl _main
_main:
    sub sp, sp, #48
    stp x29, x30, [sp, #32]
    add x29, sp, #32
    // TODO: deja &a en [sp+0], &b en [sp+8] y llama a _scanf con "%d %d" en x0
    // TODO: comprueba que w0 vale 2; si no vale 2, sal a fin
    // TODO: lee a y b, súmalos en w8 y llama a _printf con "suma=%d"
fin:
    mov w0, #0
    ldp x29, x30, [sp, #32]
    add sp, sp, #48
    ret

.data
fmt1: .asciz "%d %d"
fmt2: .asciz "suma=%d\n"
ASM

as suma.s -o suma.o
clang suma.o -o suma
./suma
