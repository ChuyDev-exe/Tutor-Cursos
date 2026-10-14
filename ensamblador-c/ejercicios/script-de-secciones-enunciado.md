# Script de secciones

Este script escribe un **linker script** de GNU (`linker.lds`) y después lo valida línea a línea. El validador ya está escrito: tú solo tienes que escribir el script para que todas las comprobaciones den `ok` y la última línea diga `script: valido`.

El validador busca exactamente estos textos:

| Texto | Qué comprueba |
|---|---|
| `SECTIONS` | el bloque de secciones existe |
| `. = ` | una línea que mueve el contador de ubicación |
| `.text : {` | la sección de salida `.text` |
| `*(.text)` | el comodín que mete la `.text` de todos los objetos |
| `.rodata : {` | la sección de salida `.rodata` |
| `/DISCARD/` | el bloque que tira secciones |

Y además comprueba que las llaves `{` y `}` están equilibradas.

## Entrada

No se lee entrada. El script ignora lo que haya en `stdin`.

## Salida

Ocho líneas:

```
secciones: ok
direccion: ok
text: ok
comodin text: ok
rodata: ok
discard: ok
llaves: ok
script: valido
```

Si falta algo, esa línea dice `falta` (o `mal`, en el caso de las llaves) y la última pasa a ser `script: incompleto`.

## Ejemplo

Salida esperada con el script correcto: las ocho líneas anteriores, tal cual.
