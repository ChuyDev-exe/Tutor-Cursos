# Etiqueta con tipo

Escribe el componente `Etiqueta` para que pinte una etiqueta HTML cuyo tipo llega por props.

La plantilla ya incluye el mini React (`h` y `renderToString`) y el código que lee la entrada. No modifiques esa parte. Completa solo la función marcada con `TODO`.

## Entrada

Una línea con dos partes separadas por un espacio:

1. El tipo de etiqueta: `span`, `h2`, `p`…
2. El texto de la etiqueta. Puede contener espacios.

Ejemplo de entrada: `span Importante`

## Salida

Exactamente este formato, con el tipo y el texto recibidos. La etiqueta se cierra con el mismo tipo con el que se abre:

`<span className="etiqueta">Importante</span>`

La prop `className` siempre vale `etiqueta`. No imprimas nada más.

## Ejemplo

Entrada: `h2 Aviso`  →  Salida: `<h2 className="etiqueta">Aviso</h2>`

Entrada: `p Detalle menor`  →  Salida: `<p className="etiqueta">Detalle menor</p>`
