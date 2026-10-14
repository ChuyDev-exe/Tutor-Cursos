#!/usr/bin/env bash
set -euo pipefail

# Escribe aqui tu linker script con el mapa MEMORY
cat > linker.lds <<'EOF'
# TODO: escribe aqui el mapa MEMORY y las tres secciones del enunciado
EOF

fallos=0
chequea(){ if grep -qF "$1" linker.lds; then echo "$2: ok"; else echo "$2: falta"; fallos=$((fallos+1)); fi; }

chequea "MEMORY" "memoria"
chequea "ORIGIN =" "origen"
chequea "LENGTH =" "longitud"
chequea "*(.text)" "text"
chequea "*(.data)" "data"
chequea "*(.bss)" "bss"
chequea "> FLASH" "flash"
chequea "> RAM" "ram"

abre=$(grep -o "{" linker.lds | wc -l | tr -d ' ')
cierra=$(grep -o "}" linker.lds | wc -l | tr -d ' ')
if [ "$abre" -gt 0 ] && [ "$abre" = "$cierra" ]; then echo "llaves: ok"; else echo "llaves: mal"; fallos=$((fallos+1)); fi

if [ "$fallos" -eq 0 ]; then echo "script: valido"; else echo "script: incompleto"; fi
