```bash
#!/usr/bin/env bash
set -euo pipefail

caso=""
read -r caso || true

cat > pieza.s <<'ASM'
.text
.globl _saluda
_saluda:
    mov w0, #1
    ret
_interna:
    mov w0, #2
    ret
ASM

cat > main.s <<'ASM'
.text
.globl _main
_main:
    bl _saluda
    mov w0, #0
    ret
ASM

as pieza.s -o pieza.o
as main.s -o main.o

objeto=$(nm pieza.o | awk '$2=="T"||$2=="t"{print $2" "$3}' | grep -E '_(saluda|interna)' | LC_ALL=C sort | xargs)

clang main.o pieza.o -o prog

enlace=$(nm prog | awk '$2=="T"{print $2" "$3}' | grep -E '_(saluda|interna)' | xargs)

case "$caso" in
  objeto) echo "objeto: $objeto" ;;
  enlace) echo "enlace: $enlace" ;;
  *) echo "objeto: $objeto"; echo "enlace: $enlace" ;;
esac
```

`T` y `t` son la misma función con distinto alcance: la mayúscula dice que el símbolo es visible para otros archivos y la minúscula que solo existe en el suyo. `_interna` se compila igual que `_saluda`, pero al enlazar desaparece de la tabla del ejecutable porque nadie de fuera puede referirse a ella. Es lo mismo que hace `static` en C.
