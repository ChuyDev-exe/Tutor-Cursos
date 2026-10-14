```bash
#!/usr/bin/env bash
set -euo pipefail

caso=""
read -r caso || true

cat > fa.s <<'ASM'
.text
.globl _fa
_fa:
    mov w0, #1
    ret
ASM

cat > fb.s <<'ASM'
.text
.globl _fb
_fb:
    mov w0, #2
    ret
ASM

as fa.s -o fa.o
as fb.s -o fb.o

if [ "$caso" = "dup" ]; then
  cat > dup.s <<'ASM'
.text
.globl _fa
_fa:
    mov w0, #9
    ret
ASM
  as dup.s -o dup.o
  ( (ld -r fa.o dup.o -o mal.o 2>&1 || true) | grep -o "duplicate symbol" | head -1 | sed 's/^/fusion: /' )
else
  echo "secciones antes: $(objdump -h fa.o fb.o | grep -c '__text')"

  ld -r fa.o fb.o -o todo.o

  echo "secciones despues: $(objdump -h todo.o | grep -c '__text')"
  echo "simbolos: $(nm todo.o | awk '$2=="T"{print $3}' | xargs)"
fi
```

Antes hay dos objetos con un `__text` cada uno. `ld -r` los fusiona en un solo `.o` con una única sección `__text` del doble de tamaño, y las dos etiquetas (`T _fa`, `T _fb`) siguen en su tabla de símbolos. Con dos definiciones de `_fa` en lugar de una, la misma orden se queja con `duplicate symbol` antes de escribir nada: el enlazador comprueba los duplicados al fusionar.
