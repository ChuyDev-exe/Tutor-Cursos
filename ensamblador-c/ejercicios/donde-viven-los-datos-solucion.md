```bash
#!/usr/bin/env bash
set -euo pipefail

cat > datos.c <<'EOF'
#include <stdio.h>
int inicial = 42;
int sin_inicializar;
const char mensaje[] = "hola";
int main(void){ printf("%d\n", inicial + sin_inicializar + mensaje[0]); return 0; }
EOF

gcc -c datos.c -o datos.o
clang datos.o -o prog

seccion(){ nm -m prog | awk -v s="$1" '$4==s {gsub(/[()]/,"",$2); print $2}'; }

caso=""
read -r caso || true

case "$caso" in
  data)
    echo "inicializado: $(seccion _inicial)"
    ;;
  const)
    echo "constante: $(seccion _mensaje)"
    ;;
  bss)
    echo "sin inicializar: $(seccion _sin_inicializar)"
    echo "bss: $(objdump -h prog | awk '$5=="BSS"{print $2" "$5}')"
    ;;
  *)
    echo "inicializado: $(seccion _inicial)"
    echo "constante: $(seccion _mensaje)"
    echo "sin inicializar: $(seccion _sin_inicializar)"
    echo "bss: $(objdump -h prog | awk '$5=="BSS"{print $2" "$5}')"
    ;;
esac
```

Los tres casos cubren las tres familias: `inicial` tiene valor escrito y vive en `__DATA,__data`; `mensaje` es `const` y vive en `__TEXT,__const`, de solo lectura; `sin_inicializar` no ocupa sitio en el archivo y cae en `__DATA,__common`, que `objdump -h` marca como tipo `BSS`. Esa es la `.bss` de Mach-O: la misma idea de la que habla el capítulo, con otro nombre de sección.
