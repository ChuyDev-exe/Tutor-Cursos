# Limpiar la .bss

En un sistema embebido, quien pone a cero la `.bss` es la rutina de arranque, y lo hace recorriendo el rango entre dos símbolos. Este ejercicio es ese bucle: la función `_limpiar` recibe en `x0` el principio y en `x1` el final, y debe dejar todos los bytes a cero.

El `main` de C rellena `n` bytes con un valor distinto de cero, llama a `_limpiar` y comprueba cuántos siguen sin ser cero.

Completa el cuerpo de `_limpiar` en `limpiar.s`.

## Entrada

Una línea con un entero `n` (se recorta al intervalo 0…64).

## Salida

Dos líneas:

```
no cero antes: N
no cero despues: 0
```

## Ejemplo

Entrada: `8`

Salida:

```
no cero antes: 8
no cero despues: 0
```
