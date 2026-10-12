Para duplicar el valor en `w8` usa `add w8, w8, w8`. Después deja el resultado en la pila con `str w8, [sp]`, carga el formato `doble=%d` en `x0` con `adrp` más `add` y llama a `bl _printf`.
