# Global y local

`pieza.s` contiene dos funciones: `_saluda`, marcada con `.globl`, y `_interna`, que no lo está. El script las lista con `nm` en el objeto y después en el ejecutable.

Hay dos líneas marcadas con `TODO`, una para cada lista. Recuerda que `nm` usa mayúscula para lo global y minúscula para lo local.

## Entrada

Una palabra en una línea:

- `objeto`: solo la lista del `.o`.
- `enlace`: solo la lista del ejecutable.
- cualquier otra cosa: las dos listas.

## Salida

Con `objeto`:

```
objeto: T _saluda t _interna
```

Con `enlace`:

```
enlace: T _saluda
```

## Ejemplo

Entrada: `objeto`

Salida:

```
objeto: T _saluda t _interna
```
