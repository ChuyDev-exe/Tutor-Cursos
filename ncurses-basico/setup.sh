#!/usr/bin/env bash
# Setup del curso «ncurses básico». Sin red, sin sudo: comprueba gcc y ncurses y crea tu carpeta de trabajo.
set -euo pipefail

WS="${TUTOR_WORKSPACE:-$PWD}"

command -v gcc >/dev/null || { echo "ERROR: falta gcc (ver MANUAL.md)"; exit 1; }
echo "gcc: $(gcc --version | head -1)"

mkdir -p "$WS/ncurses-basico"
PRUEBA="$WS/ncurses-basico/.prueba-ncurses"
if printf '#include <ncurses.h>\nint main(void) { return 0; }\n' | gcc -x c - -lncurses -o "$PRUEBA" 2>/dev/null; then
  echo "ok:  ncurses compila y enlaza"
  rm -f "$PRUEBA"
else
  echo "ERROR: no se pudo compilar con ncurses (instala libncurses-dev; ver MANUAL.md)"
  exit 1
fi

echo "Listo: entorno preparado. Tu carpeta de trabajo es $WS/ncurses-basico"
