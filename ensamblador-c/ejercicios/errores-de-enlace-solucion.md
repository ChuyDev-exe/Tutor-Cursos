```bash
#!/usr/bin/env bash
set -euo pipefail

caso=""
read -r caso || true

case "$caso" in
  dup)
    cat > a.s <<'ASM'
.globl _dup
_dup:
    mov w0, #1
    ret
ASM
    cat > b.s <<'ASM'
.globl _dup
_dup:
    mov w0, #2
    ret
ASM
    cat > m.c <<'C'
int dup(void);
int main(void){ return dup(); }
C
    gcc -c a.s -o a.o
    gcc -c b.s -o b.o
    gcc -c m.c -o m.o
    ( (clang m.o a.o b.o -o prog 2>&1 || true) | grep -o "duplicate symbol" | head -1 )
    ;;
  undef)
    cat > m.c <<'C'
int no_existe(void);
int main(void){ return no_existe(); }
C
    gcc -c m.c -o m.o
    ( (clang m.o -o prog 2>&1 || true) | grep -o "Undefined symbols" | head -1 )
    ;;
esac

exit 0
```

La idea: el enlace falla a propósito, así que se une stderr a stdout con `2>&1` y `|| true` evita que `set -e` termine el script. `grep -o` deja en la salida solo la frase del error y `head -1` imprime una sola línea.
