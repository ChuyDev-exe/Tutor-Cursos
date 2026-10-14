# El enlazador travieso

`libayuda.a` es una biblioteca estática con una función `helper`. El script la enlaza contra un `main` y responde con `nm` si el miembro de la biblioteca ha terminado dentro del ejecutable.

Las tres líneas marcadas con `TODO` son las órdenes de enlace, y las tres están mal:

1. En el caso `llama`, la orden no encuentra la biblioteca.
2. En el caso `sin`, se enlaza un `.o` suelto en lugar de la biblioteca.
3. En el caso `fuerza`, el `main` no llama a nada de la biblioteca y hay que arrastrar el miembro a la fuerza.

La consulta final con `nm` ya está escrita.

## Entrada

Una palabra en una línea:

- `llama`: el `main` llama a `helper`.
- `sin`: el `main` no llama a nada de la biblioteca.
- `fuerza`: el `main` no llama, pero hay que forzar la carga.

## Salida

Una sola línea:

```
helper: si
```

o

```
helper: no
```

## Ejemplo

Entrada: `sin`  →  Salida: `helper: no`

Entrada: `fuerza`  →  Salida: `helper: si`
