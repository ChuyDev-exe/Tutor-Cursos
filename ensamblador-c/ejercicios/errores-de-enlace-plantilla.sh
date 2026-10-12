#!/usr/bin/env bash
set -euo pipefail

# El script provoca un error de enlace y debe mostrar solo una frase.
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
    # TODO: enlaza los tres .o y muestra solo "duplicate symbol"
    ;;
  undef)
    cat > m.c <<'C'
int no_existe(void);
int main(void){ return no_existe(); }
C
    gcc -c m.c -o m.o
    # TODO: enlaza m.o y muestra solo "Undefined symbols"
    ;;
esac

exit 0
