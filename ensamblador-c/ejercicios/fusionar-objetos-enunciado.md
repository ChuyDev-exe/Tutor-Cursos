# Fusionar objetos

El script monta dos pequeños archivos de ensamblador y los pasa al enlazador. Hay tres líneas marcadas con `TODO`:

1. Cuenta las secciones `__text` que tienen los dos objetos antes de fusionar.
2. Fusiona los dos objetos en uno solo (sin buscar bibliotecas del sistema).
3. En el caso `dup`, captura el error que se produce al fusionar dos objetos que definen el mismo símbolo y deja en la salida solo la frase `duplicate symbol`.

## Entrada

Una palabra en una línea:

- `fusion`: fusiona los dos objetos e imprime tres líneas.
- cualquier otra palabra: mismo comportamiento que `fusion`.

## Salida

Con `fusion`:

```
secciones antes: 2
secciones despues: 1
simbolos: _fa _fb
```

Con `dup` (dos objetos que definen `_fa`):

```
fusion: duplicate symbol
```

## Ejemplo

Entrada: `fusion`

Salida:

```
secciones antes: 2
secciones despues: 1
simbolos: _fa _fb
```
