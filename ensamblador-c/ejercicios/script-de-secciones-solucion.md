```bash
#!/usr/bin/env bash
set -euo pipefail

cat > linker.lds <<'EOF'
SECTIONS
{
  . = 0x08000000;
  .text : { *(.text) }
  .rodata : { *(.rodata*) }
  /DISCARD/ : { *(.comment) }
}
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
```

El script sigue el esqueleto de un `SECTIONS` de GNU: primero se sitúa el contador de ubicación (`. = 0x08000000;`), después se declaran las secciones de salida con sus entradas y se cierra el bloque. `*(.text)` y `*(.rodata*)` son comodines que recogen esas secciones de todos los objetos de entrada, y `/DISCARD/` tira las notas del compilador. El validador comprueba que aparecen todos los trozos y que las llaves cuadran.
