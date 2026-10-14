```bash
#!/usr/bin/env bash
set -euo pipefail

caso=""
read -r caso || true

case "$caso" in
  global)
    cat > a.c <<'EOF'
int dup(void){ return 1; }
EOF
    cat > b.c <<'EOF'
int dup(void){ return 2; }
EOF
    cat > m.c <<'EOF'
#include <stdio.h>
int dup(void);
int main(void){ printf("%d\n", dup()); return 0; }
EOF
    gcc -c a.c -o a.o
    gcc -c b.c -o b.o
    gcc -c m.c -o m.o
    ( (clang m.o a.o b.o -o prog 2>&1 || true) | grep -o "duplicate symbol" | head -1 | sed 's/^/enlace: /' )
    ;;
  static)
    cat > a.c <<'EOF'
static int dup(void){ return 1; }
int desde_a(void){ return dup(); }
EOF
    cat > b.c <<'EOF'
static int dup(void){ return 2; }
int desde_b(void){ return dup(); }
EOF
    cat > m.c <<'EOF'
#include <stdio.h>
int desde_a(void);
int desde_b(void);
int main(void){ printf("%d\n", desde_a() + desde_b()); return 0; }
EOF
    gcc -c a.c -o a.o
    gcc -c b.c -o b.o
    gcc -c m.c -o m.o
    clang m.o a.o b.o -o prog
    echo "enlace: ok"
    ;;
  guion)
    cat > suma.s <<'ASM'
.text
.globl suma
suma:
    add x0, x0, x1
    ret
ASM
    cat > m.c <<'EOF'
#include <stdio.h>
int suma(int, int);
int main(void){ printf("%d\n", suma(2, 3)); return 0; }
EOF
    gcc -c suma.s -o suma.o
    gcc -c m.c -o m.o
    ( (clang m.o suma.o -o prog 2>&1 || true) | grep -o "Undefined symbols" | head -1 | sed 's/^/enlace: /' )
    ;;
esac

exit 0
```

Los tres casos son las tres reglas del capítulo. Un símbolo global debe definirse una sola vez en todo el enlace, y ahí hay dos (`duplicate symbol`). Marcarlo `static` lo convierte en local y las dos versiones conviven sin problema. Y el guion bajo de Mach-O no es optativo: sin él, C busca `_suma` y el enlazador no lo encuentra (`Undefined symbols`).
