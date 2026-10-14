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

gcc -c doble.c -o doble.o
gcc -c main.c -o main.o

echo "objeto: $(nm main.o | awk '$1=="U" && $2=="_doble"{print $1" "$2}')"

clang main.o doble.o -o prog -Wl,-map,prog.map

echo "ejecutable: $(nm prog | awk '$3=="_doble"{print $2" "$3}')"
echo "mapa: $(awk '$4=="__text"{print $3" "$4; exit}' prog.map)"
echo "programa: $(./prog)"
```

En `main.o`, `_doble` es una referencia sin resolver: `U`. En `main.o` la línea no tiene dirección, por eso `$1` es la letra y `$2` el nombre; en el ejecutable sí la tiene, así que la letra cae en `$2` y el nombre en `$3`. Tras enlazar, la `U` se convierte en una `T` con dirección real y el mapa confirma dónde ha quedado el código: segmento `__TEXT`, sección `__text`.
