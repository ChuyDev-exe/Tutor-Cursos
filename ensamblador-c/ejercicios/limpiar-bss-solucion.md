```bash
#!/usr/bin/env bash
set -euo pipefail

cat > limpiar.s <<'ASM'
.text
.globl _limpiar
_limpiar:
    b 2f
1:
    strb wzr, [x0], #1
2:
    cmp x0, x1
    b.lo 1b
    ret
ASM

cat > main.c <<'EOF'
#include <stdio.h>
unsigned char zona[64];
extern void limpiar(void *, void *);
int main(void){
    int n, i, antes = 0, despues = 0;
    if (scanf("%d", &n) != 1) return 0;
    if (n < 0) n = 0;
    if (n > 64) n = 64;
    for (i = 0; i < n; i++) zona[i] = 0x5A;
    for (i = 0; i < n; i++) if (zona[i]) antes++;
    limpiar(zona, zona + n);
    for (i = 0; i < n; i++) if (zona[i]) despues++;
    printf("no cero antes: %d\n", antes);
    printf("no cero despues: %d\n", despues);
    return 0;
}
EOF

gcc -c limpiar.s -o limpiar.o
gcc -c main.c -o main.o
clang main.o limpiar.o -o prog
./prog
```

El bucle salta a la etiqueta `2`, comprueba `x0 < x1` y, si es así, escribe un byte cero y avanza el puntero con `strb wzr, [x0], #1`. Cuando `x0` llega a `x1`, `b.lo` no salta y cae en el `ret`. Eso es literalmente lo que hace una rutina de arranque con los símbolos `_sbss` y `_ebss`: recorrer el hueco que el linker script dejó reservado para la `.bss` y dejarlo a cero antes de llamar a `main`. `zona` vive en la `.bss` del ejecutable por estar sin inicializar, así que la idea es la misma.
