```bash
#!/usr/bin/env bash
set -euo pipefail

cat > suma.s <<'ASM'
.globl _main
_main:
    sub sp, sp, #48
    stp x29, x30, [sp, #32]
    add x29, sp, #32
    // scanf("%d %d", &a, &b): a vive en [x29-4] y b en [x29-8]
    sub x8, x29, #4
    str x8, [sp]
    sub x9, x29, #8
    str x9, [sp, #8]
    adrp x0, fmt1@PAGE
    add x0, x0, fmt1@PAGEOFF
    bl _scanf
    cmp w0, #2
    b.ne fin
    ldur w8, [x29, #-4]
    ldur w9, [x29, #-8]
    add w8, w8, w9
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
fmt1: .asciz "%d %d"
fmt2: .asciz "suma=%d\n"
ASM

as suma.s -o suma.o
clang suma.o -o suma
./suma
```

Las dos direcciones ocupan huecos seguidos de la pila: `&a` en `[sp+0]` y `&b` en `[sp+8]`, con el formato `"%d %d"` en `x0`. `cmp w0, #2` comprueba que `scanf` leyó los dos números. La suma se hace con `add w8, w8, w9` y se imprime desde la pila.
