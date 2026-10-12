# Buscador con filtro

Escribe el componente `Buscador`, que filtra una lista de productos según el texto escrito en un input.

El filtrado se calcula en cada render: es un valor derivado. No necesita estado propio ni efectos.

## Entrada

Dos partes, en este orden:

1. La primera línea son los productos separados por espacio.
2. El resto son eventos: `cambiar 1 texto` escribe en el input de búsqueda.

## Salida

Una línea por cada render.

- El primer `<p>` lista los productos que **incluyen** el texto, unidos con `, `. Si no queda ninguno, se imprime `sin resultados`.
- El segundo `<p>` imprime `coincidencias: <n>`.

Con el texto vacío se incluyen todos los productos. «Incluir» es buscar el texto como subcadena: `ga` coincide con `gato` pero no con `agua`.

## Ejemplo

Entrada:
```
pan gato agua
cambiar 1 ga
```

Salida:
```
<div><input value=""></input><p>pan, gato, agua</p><p>coincidencias: 3</p></div>
<div><input value="ga"></input><p>gato</p><p>coincidencias: 1</p></div>
```
