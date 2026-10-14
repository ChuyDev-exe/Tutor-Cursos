# Script de memoria

Este script escribe un linker script con un mapa `MEMORY` de dos bloques (flash y RAM) y coloca cada sección en su bloque. El validador ya está escrito y comprueba diez cosas; tú solo tienes que escribir `linker.lds` para que todas den `ok`.

| Texto buscado | Qué comprueba |
|---|---|
| `MEMORY` | el mapa de memoria existe |
| `ORIGIN =` | dirección de arranque de cada bloque |
| `LENGTH =` | tamaño de cada bloque |
| `*(.text)` | entradas de la sección de código |
| `*(.data)` | entradas de la sección de datos |
| `*(.bss)` | entradas de la sección sin inicializar |
| `> FLASH` | `.text` colocada en la flash |
| `> RAM` | `.data` y `.bss` colocadas en la RAM |

Además comprueba que las llaves están equilibradas.

## Entrada

No se lee entrada.

## Salida

Diez líneas:

```
memoria: ok
origen: ok
longitud: ok
text: ok
data: ok
bss: ok
flash: ok
ram: ok
llaves: ok
script: valido
```

Si falta algo, esa línea dice `falta` (o `mal`, en el caso de las llaves) y la última pasa a ser `script: incompleto`.

## Ejemplo

Salida esperada con el script correcto: las diez líneas anteriores, tal cual.
