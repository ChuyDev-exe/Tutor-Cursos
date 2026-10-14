# Descarte en el mismo archivo

`piezas.s` define dos funciones: `_usada` y `_hueca`. El `main` que se genera llama solo a una de las dos, y el script enlaza dos veces: primero sin descartar nada y después con `-Wl,-dead_strip`.

Las dos líneas marcadas con `TODO` son las dos órdenes de enlace.

## Entrada

Una palabra en una línea que decide a qué llama el `main`:

- `usada`: llama a `_usada`.
- `hueca`: llama a `_hueca`.
- `ambas`: llama a las dos.

## Salida

Dos líneas, en este orden:

```
sin descarte: _hueca _usada
con descarte: <los símbolos que siguen tras descartar>
```

## Ejemplo

Entrada: `usada`

Salida:

```
sin descarte: _hueca _usada
con descarte: _usada
```
