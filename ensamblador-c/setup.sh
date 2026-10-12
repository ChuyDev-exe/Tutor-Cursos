#!/usr/bin/env bash
# Setup del curso «Ensamblador y C». Sin red, sin sudo: comprueba la toolchain y crea tu carpeta de trabajo.
set -euo pipefail

WS="${TUTOR_WORKSPACE:-$PWD}"

command -v gcc >/dev/null || { echo "ERROR: falta gcc (ver MANUAL.md: xcode-select --install)"; exit 1; }
command -v make >/dev/null || { echo "ERROR: falta make (ver MANUAL.md: xcode-select --install)"; exit 1; }

echo "gcc:  $(gcc --version | head -1)"
echo "make: $(make --version | head -1)"

for herramienta in as clang nm ar objdump; do
  if command -v "$herramienta" >/dev/null; then
    echo "ok:   $herramienta encontrado"
  else
    echo "aviso: no encontré $herramienta (instala las herramientas de desarrollador)"
  fi
done

if [ "$(uname -s)" != "Darwin" ] || [ "$(uname -m)" != "arm64" ]; then
  echo "aviso: este curso usa macOS con chip Apple (arm64). Tu sistema es $(uname -s) $(uname -m)."
  echo "       Los capítulos teóricos funcionan en cualquier sistema; los ejercicios ejecutables necesitan arm64."
fi

mkdir -p "$WS/ensamblador-c"
echo "Listo: entorno preparado. Tu carpeta de trabajo es $WS/ensamblador-c"
