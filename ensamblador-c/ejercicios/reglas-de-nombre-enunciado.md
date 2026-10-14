# Reglas de nombre

Tres casos que tocan las reglas de nombrado de los símbolos. El script lee una palabra y prepara los archivos correspondientes; hay tres cosas que completar.

1. Con `global`, dos archivos definen la misma función y el enlace falla: captura el error y deja en la salida solo `duplicate symbol`.
2. Con `static`, los dos archivos definen lo mismo pero **no deben chocar**: arregla el C para que las dos versiones sean locales.
3. Con `guion`, el ensamblador define `suma` sin guion bajo y C busca `_suma`: captura el error y deja solo `Undefined symbols`.

## Entrada

Una palabra en una línea: `global`, `static` o `guion`.

## Salida

Una sola línea:

- `global` → `enlace: duplicate symbol`
- `static` → `enlace: ok`
- `guion` → `enlace: Undefined symbols`

## Ejemplo

Entrada: `global`  →  Salida: `enlace: duplicate symbol`

Entrada: `static`  →  Salida: `enlace: ok`
