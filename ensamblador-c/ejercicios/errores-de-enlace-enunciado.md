# Errores de enlace

El script recibe una palabra y debe provocar y mostrar el error de enlace correspondiente. El andamiaje ya crea los archivos, los ensambla y deja el enlace listo. Tú escribes las dos líneas que capturan el error.

- Con `dup`, dos `.o` definen la misma función `_dup`.
- Con `undef`, el `.o` llama a `_no_existe` y nadie la define.

El script debe terminar siempre con código de salida 0, aunque el enlace falle.

## Entrada

Una palabra, en una línea: `dup` o `undef`.

## Salida

- Con `dup`: una línea que contiene `duplicate symbol`.
- Con `undef`: una línea que contiene `Undefined symbols`.

No imprimas nada más. El texto sale del propio enlazador, así que respeta sus mayúsculas.

## Ejemplo

Entrada: `dup`  →  Salida: `duplicate symbol`

Entrada: `undef`  →  Salida: `Undefined symbols`
