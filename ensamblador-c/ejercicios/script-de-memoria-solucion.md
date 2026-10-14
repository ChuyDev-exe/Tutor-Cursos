```bash
#!/usr/bin/env bash
set -euo pipefail

cat > linker.lds <<'EOF'
MEMORY
{
  FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 64K
  RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 16K
}
SECTIONS
{
  .text : { *(.text) }  > FLASH
  .data : { *(.data) }  > RAM
  .bss  : { *(.bss) }   > RAM
}
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
```

`MEMORY` declara los dos bloques con su dirección de arranque y su tamaño. Después, `SECTIONS` reparte: el código va a la flash, y los datos y la `.bss` a la RAM. Esa separación es la que obliga a copiar `.data` y a poner a cero `.bss` al arrancar, que es lo que verás en el capítulo siguiente. Si una sección no cabe en el bloque que se le asigna, el enlazador se niega a enlazar.
