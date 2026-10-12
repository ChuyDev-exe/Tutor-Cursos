# Valor anterior con ref

Guarda el valor anterior de un contador con `useRef`. En cada render se lee `ref.current` como `anterior`, se muestra, y después se actualiza con el valor actual.

El ref empieza en `null`: mientras no haya valor anterior se muestra `-`.

## Entrada

1. Línea 1: el valor inicial del contador. Si no hay líneas, empieza en 0.
2. Las siguientes son eventos:
   - `clic 1` → incrementa el contador en 1.

## Salida

Una línea por cada render:

```
<div><p>actual: 7 · anterior: 6</p><button>sumar</button></div>
```

El primer render siempre tiene `anterior: -`.

## Ejemplo

Entrada:
```
5
clic 1
```

Salida:
```
<div><p>actual: 5 · anterior: -</p><button>sumar</button></div>
<div><p>actual: 6 · anterior: 5</p><button>sumar</button></div>
```
