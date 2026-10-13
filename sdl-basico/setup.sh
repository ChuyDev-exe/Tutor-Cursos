#!/usr/bin/env bash
# Setup del curso «SDL2 básico». Sin red, sin sudo: comprueba gcc y SDL2 y crea tu carpeta de trabajo.
set -euo pipefail

WS="${TUTOR_WORKSPACE:-$PWD}"

command -v gcc >/dev/null || { echo "ERROR: falta gcc (ver MANUAL.md)"; exit 1; }
command -v sdl2-config >/dev/null || { echo "ERROR: falta SDL2: no encuentro sdl2-config (ver MANUAL.md)"; exit 1; }
echo "gcc:  $(gcc --version | head -1)"
echo "SDL2: $(sdl2-config --version)"

mkdir -p "$WS/sdl-basico"
PRUEBA="$WS/sdl-basico/.prueba-sdl"
# shellcheck disable=SC2046
if printf '#include <SDL.h>\nint main(int argc, char *argv[]) { (void)argc; (void)argv; return 0; }\n' \
  | gcc -x c - $(sdl2-config --cflags --libs) -o "$PRUEBA" 2>/dev/null; then
  echo "ok:   SDL2 compila y enlaza"
  rm -f "$PRUEBA"
else
  echo "ERROR: no se pudo compilar con SDL2 (ver MANUAL.md)"
  exit 1
fi

echo "Listo: entorno preparado. Tu carpeta de trabajo es $WS/sdl-basico"
