# Dónde viven los datos

El script compila un programa con los tres tipos de dato típicos y los localiza en el ejecutable con `nm -m` y `objdump -h`.

Hay dos cosas que completar:

1. La función `seccion`, que extrae la sección de un símbolo. `nm -m` imprime cada línea con este formato: dirección, sección entre paréntesis, tipo y nombre.
2. La línea que busca la sección marcada como `BSS` en `objdump -h` y enseña su nombre junto al tipo.

## Entrada

Una palabra en una línea que decide qué se imprime:

- `data`: dónde vive `inicial`.
- `const`: dónde vive `mensaje`.
- `bss`: dónde vive `sin_inicializar` y qué dice `objdump -h` de esa sección.
- cualquier otra cosa: las cuatro líneas.

## Salida

```
inicializado: __DATA,__data
constante: __TEXT,__const
sin inicializar: __DATA,__common
bss: __common BSS
```

(solo las líneas que corresponda al caso).

## Ejemplo

Entrada: `data`

Salida:

```
inicializado: __DATA,__data
```
