```bash
#!/usr/bin/env bash
set -euo pipefail

cat > suma.S <<'ASM'
#define OPER add
.text
.globl _suma
_suma:
    OPER x0, x0, x1
    ret
ASM

cat > main.c <<'EOF'
#include <stdio.h>
int suma(int, int);
int main(void){ int a, b; if (scanf("%d %d", &a, &b) != 2) return 0; printf("%d\n", suma(a, b)); return 0; }
EOF

gcc -E -P suma.S -o suma.i
grep -q "add x0, x0, x1" suma.i && echo "preproceso: add x0, x0, x1"

gcc -c main.c -o main.o

gcc -c suma.S -o suma.o
echo "objeto: $(nm suma.o | awk '$3=="_suma"{print $2" "$3}')"

clang main.o suma.o -o prog

echo "ejecutable: $(./prog)"
```

La mayúscula de `.S` es lo que hace que `gcc -c` pase el archivo por el preprocesador: en `suma.i` ya no queda `OPER`, sino `add x0, x0, x1`. Con `.s` en minúscula, `as` leería `OPER` como un mnemónico y fallaría. Después el resto es el camino normal: `gcc -c` deja el `.o` con `T _suma` y el enlace necesita los dos objetos.
