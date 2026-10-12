El error de enlace sale por la salida de error (stderr), no por la estándar. Redirígela con `2>&1` y usa `|| true` para que `set -e` no termine el script cuando el enlace falle.
