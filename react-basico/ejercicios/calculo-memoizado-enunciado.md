# Calculo memoizado

Memoriza un filtro con `useMemo` para que `contar` no se repita en cada render. El andamiaje cuenta los cálculos e imprime `calculos=<n>` al final: tu objetivo es que ese número sea el mínimo, uno por cada texto distinto.

`Buscador({ texto, lista })` tiene un `<input>` controlado (`value` + `onChange`) guardado con `useState(texto)`. El resultado de `contar(valor, lista)` debe memorizarse con `useMemo` y deps correctas: se recalcula solo cuando cambia lo que el cálculo usa.

## Entrada

1. Línea 1: el texto inicial del input.
2. Línea 2: los elementos de la lista separados por espacio. Si está vacía, la lista es `[]`.
3. Las siguientes son eventos:
   - `cambiar 1 texto` → cambia el valor del input (el N-ésimo `onChange`, aquí el 1).

## Salida

Una línea por cada render: el `<div>` con el `<input>` y los resultados en un `<p>`, separados por espacio. Cada evento imprime un render, pero el filtro memorizado no se repite.

Al final, una línea más: `calculos=<n>`, el número de veces que se ejecutó `contar`.

## Ejemplo

Entrada:
```
pa
pan paella gato
cambiar 1 ga
```

Salida:
```
<div><input value="pa"></input><p>pan paella</p></div>
<div><input value="ga"></input><p>gato</p></div>
calculos=2
```
