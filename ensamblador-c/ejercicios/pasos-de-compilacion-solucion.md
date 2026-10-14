```bash
#!/usr/bin/env bash
set -euo pipefail

cat > doble.c <<'EOF'
int doble(int a) { return a * 2; }
EOF

cat > main.c <<'EOF'
#include <stdio.h>
int doble(int);
int main(void) { int a; if (scanf("%d", &a) != 1) return 0; printf("%d\n", doble(a)); return 0; }
EOF

gcc -E -P doble.c -o doble.i
grep -q "int doble" doble.i && echo "preproceso: ok"

gcc -S doble.c -o doble.s
grep -o "^_doble:" doble.s | head -1 | sed 's/^/ensamblador: /'

gcc -c main.c -o main.o

gcc -c doble.c -o doble.o
echo "objeto: $(nm doble.o | awk '$3=="_doble"{print $2" "$3}')"

clang main.o doble.o -o prog

echo "ejecutable: $(./prog)"
```

Las cuatro opciones, en orden: `-E -P` preprocesa (el `#include` ya no está, pero la función sí), `-S` escribe el ensamblador con la etiqueta `_doble:`, `-c` deja el `.o` con `T _doble` en su tabla de símbolos y la orden de enlace necesita los dos `.o`. El último paso es el único que se lleva la entrada de `stdin`, así que el doble se calcula al ejecutar `./prog`.
