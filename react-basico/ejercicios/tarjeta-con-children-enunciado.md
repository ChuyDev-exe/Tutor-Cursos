# Tarjeta con children

Escribe el componente `Tarjeta` para que pinte una tarjeta con título y cuerpo.

La plantilla ya incluye el mini React y lee la entrada. No modifiques esa parte. Completa solo la función marcada con `TODO`.

## Entrada

Varias líneas:

1. La primera línea es el título.
2. Las siguientes son los párrafos del cuerpo, uno por línea.

## Salida

Exactamente:

`<div className="tarjeta"><h2 className="titulo">Noticias</h2><div className="cuerpo"><p>Hola</p><p>Mundo</p></div></div>`

La estructura fija es: un `div` con clase `tarjeta`; dentro, un `h2` con clase `titulo` y el título; y después un `div` con clase `cuerpo` que contiene todos los párrafos recibidos. No imprimas nada más.

## Ejemplo

Entrada:
```
Noticias
Hola
Mundo
```

Salida: `<div className="tarjeta"><h2 className="titulo">Noticias</h2><div className="cuerpo"><p>Hola</p><p>Mundo</p></div></div>`
