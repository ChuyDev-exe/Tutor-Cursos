# Simbolos con nm

Escribe un script bash que crea `suma.s` con la función `_suma`, la ensambla a `suma.o` y muestra los símbolos del archivo objeto con `nm`, filtrados para que salga la línea de `_suma`.

## Entrada
No se lee entrada. El script no usa stdin.

## Salida
Una línea que contiene `T _suma` (dirección, letra T mayúscula, guion bajo y nombre).

## Ejemplo
Entrada: (ninguna)  →  Salida: `0000000000000000 T _suma`
