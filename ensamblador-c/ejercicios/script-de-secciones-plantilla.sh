#!/usr/bin/env bash
set -euo pipefail

# Escribe aqui tu linker script GNU
cat > linker.lds <<'EOF'
# TODO: escribe aqui el linker script pedido en el enunciado
EOF

fallos=0
chequea(){ if grep -qF "$1" linker.lds; then echo "$2: ok"; else echo "$2: falta"; fallos=$((fallos+1)); fi; }

chequea "SECTIONS" "secciones"
chequea ". = " "direccion"
chequea ".text : {" "text"
chequea "*(.text)" "comodin text"
chequea ".rodata : {" "rodata"
chequea "/DISCARD/" "discard"

abre=$(grep -o "{" linker.lds | wc -l | tr -d ' ')
cierra=$(grep -o "}" linker.lds | wc -l | tr -d ' ')
if [ "$abre" -gt 0 ] && [ "$abre" = "$cierra" ]; then echo "llaves: ok"; else echo "llaves: mal"; fallos=$((fallos+1)); fi

if [ "$fallos" -eq 0 ]; then echo "script: valido"; else echo "script: incompleto"; fi
