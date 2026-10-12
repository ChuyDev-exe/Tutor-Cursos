```bash
#!/usr/bin/env bash
set -euo pipefail

cat > doble.s <<'ASM'
.globl _main
_main:
    sub sp, sp, #48
    stp x29, x30, [sp, #32]
    add x29, sp, #32
    // scanf("%d", &n): n vive en [x29-4]; &n va a [sp+0]
    sub x8, x29, #4
    str x8, [sp]
    adrp x0, fmt1@PAGE
    add x0, x0, fmt1@PAGEOFF
    bl _scanf
    cmp w0, #1
    b.ne fin
    // doble = n + n
    ldur w8, [x29, #-4]
    add w8, w8, w8
    str w8, [sp]
    adrp x0, fmt2@PAGE
    add x0, x0, fmt2@PAGEOFF
    bl _printf
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
```

La dirección `&n` va en `[sp+0]`, no en `x1`: en macOS los argumentos de `scanf` y `printf` van por la pila. `cmp w0, #1` más `b.ne fin` salen sin imprimir si `scanf` no leyó el entero. `add w8, w8, w8` duplica el valor.
