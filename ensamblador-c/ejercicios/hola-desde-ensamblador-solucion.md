```bash
#!/usr/bin/env bash
set -euo pipefail

cat > hola.s <<'ASM'
.globl _main
_main:
    sub sp, sp, #48
    stp x29, x30, [sp, #32]
    add x29, sp, #32
    adrp x0, saludo@PAGE
    add x0, x0, saludo@PAGEOFF
    bl _printf
    mov w0, #0
    ldp x29, x30, [sp, #32]
    add sp, sp, #48
    ret

.data
saludo: .asciz "Hola desde ensamblador\n"
ASM

as hola.s -o hola.o
clang hola.o -o hola
./hola
```

El prólogo y el epílogo guardan y restauran `x29` y `x30`, porque `_main` llama a `_printf`. La dirección del string va en `x0` con `adrp` más `add`, y el `\n` va dentro del propio string.
