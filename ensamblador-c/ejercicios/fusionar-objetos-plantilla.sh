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
  # TODO: fusiona fa.o y dup.o y deja en la salida solo "duplicate symbol"
  ld -r fa.o dup.o -o mal.o
else
  # TODO: cuenta las secciones __text de fa.o y fb.o juntos
  echo "secciones antes: $(objdump -h fa.o | grep -c '__text')"

  # TODO: fusiona fa.o y fb.o en un solo archivo objeto
  ld fa.o fb.o -o todo.o

  echo "secciones despues: $(objdump -h todo.o | grep -c '__text')"
  echo "simbolos: $(nm todo.o | awk '$2=="T"{print $3}' | xargs)"
fi
