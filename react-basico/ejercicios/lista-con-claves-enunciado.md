# Lista con claves

Escribe el componente `Lista` para que pinte una lista no ordenada con una `key` por cada elemento.

La plantilla ya incluye el mini React y convierte la entrada en un array de textos (`items`). Tu trabajo es solo el componente.

## Entrada

Una línea con los elementos separados por espacios.

Si la entrada está vacía, `items` llega como un array vacío.

## Salida

Exactamente:

`<ul><li key="perro">perro</li><li key="gato">gato</li></ul>`

Cada `li` lleva la prop `key` con el propio texto como valor. Con un array vacío la salida es `<ul></ul>`. No imprimas nada más.

## Ejemplo

Entrada: `perro gato`  →  Salida: `<ul><li key="perro">perro</li><li key="gato">gato</li></ul>`

Entrada: `` (vacía)  →  Salida: `<ul></ul>`
