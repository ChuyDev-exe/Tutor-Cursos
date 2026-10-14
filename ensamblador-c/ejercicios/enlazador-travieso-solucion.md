```bash
#!/usr/bin/env bash
set -euo pipefail

cat > ayuda.c <<'EOF'
int helper(void) { return 5; }
EOF

cat > con.c <<'EOF'
#include <stdio.h>
int helper(void);
int main(void){ printf("hola\n"); return helper(); }
EOF

cat > sin.c <<'EOF'
#include <stdio.h>
int main(void){ printf("hola\n"); return 0; }
EOF

gcc -c ayuda.c -o ayuda.o
ar rcs libayuda.a ayuda.o

caso=""
read -r caso || true

case "$caso" in
  llama)
    gcc -c con.c -o con.o
    clang con.o -L. -layuda -o prog
    ;;
  sin)
    gcc -c sin.c -o sin.o
    clang sin.o -L. -layuda -o prog
    ;;
  fuerza)
    gcc -c sin.c -o sin.o
    clang sin.o -L. -layuda -Wl,-u,_helper -o prog
    ;;
esac

if nm prog | grep -q " _helper$"; then echo "helper: si"; else echo "helper: no"; fi
```

El enlazador solo mete un miembro de biblioteca si algo lo necesita: con `sin` no entra ni una instrucción de `ayuda.o` y el ejecutable sale sin `_helper`. Con `llama`, la llamada arrastra al miembro sin que tú hagas nada más. `-Wl,-u,_helper` es la orden explícita para el caso en que lo quieres dentro aunque nadie lo llame: marcas el símbolo como imprescindible y el enlazador obedece. Enlazar `ayuda.o` directamente funciona, pero ya no es una biblioteca: todo su contenido entra siempre.
