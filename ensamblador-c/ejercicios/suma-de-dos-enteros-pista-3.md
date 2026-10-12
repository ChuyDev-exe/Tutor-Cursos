Carga `a` y `b` con `ldur w8, [x29, #-4]` y `ldur w9, [x29, #-8]`, súmalos con `add w8, w8, w9`, deja el resultado en `[sp]` con `str w8, [sp]` y llama a `bl _printf` con el formato `suma=%d`.
