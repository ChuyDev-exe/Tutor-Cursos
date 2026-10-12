```bash
#!/usr/bin/env bash
set -euo pipefail

cat > suma.s <<'ASM'
.globl _suma
_suma:
    add x0, x0, x1
    ret
ASM

as suma.s -o suma.o
nm suma.o | grep suma
```

`.globl _suma` marca la etiqueta como símbolo global. Por eso `nm` la lista con la letra `T`: está definida en la sección de texto (código). En Mach-O el nombre lleva guion bajo.
