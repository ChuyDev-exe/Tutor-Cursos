.globl _main
_main:
    sub sp, sp, #48
    stp x29, x30, [sp, #32]
    add x29, sp, #32
    // TODO: carga la dirección de saludo en x0 (adrp + add) y llama a bl _printf
    mov w0, #0
    ldp x29, x30, [sp, #32]
    add sp, sp, #48
    ret

.data
saludo: .asciz "Hola desde ensamblador\n"
