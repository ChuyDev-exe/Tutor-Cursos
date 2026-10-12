#!/usr/bin/env bash
# Setup del curso «React desde cero». Sin red, sin sudo: comprueba Node y crea tu carpeta de trabajo.
set -euo pipefail

WS="${TUTOR_WORKSPACE:-$PWD}"

command -v node >/dev/null || { echo "ERROR: falta node (ver MANUAL.md)"; exit 1; }
node --version

mkdir -p "$WS/react-basico"
echo "Listo: entorno preparado. Tu carpeta de trabajo es $WS/react-basico"
