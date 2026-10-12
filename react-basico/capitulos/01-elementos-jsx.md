# 1. Elementos: qué es JSX por dentro

## Objetivo

Al terminar este capítulo sabrás qué es un elemento de React y qué hace el compilador con cada línea de JSX.

## Qué es JSX

En los proyectos de React casi siempre se escribe JSX:

```jsx
<p id="saludo">Hola, Ana</p>
```

JSX no es JavaScript puro. Un compilador lo transforma antes de ejecutarlo. La forma resultante es una llamada a una función:

```js
h("p", { id: "saludo" }, "Hola, Ana")
```

La función `h` se llama `createElement` en React. Significa: crea un elemento. Sus tres partes son:

1. El **tipo**: el nombre de la etiqueta, como texto (`"p"`).
2. Las **props**: un objeto con los datos (`{ id: "saludo" }`).
3. Los **hijos**: lo que va dentro de la etiqueta.

En este curso escribes la forma con `h(...)` porque el editor ejecuta JavaScript con `node` y no hay compilador de JSX. Es la misma idea: JSX es azúcar; `h` es lo que hay debajo.

## El elemento es un objeto

`h("p", { id: "saludo" }, "Hola, Ana")` devuelve un objeto simple:

```js
{
  type: "p",
  props: { id: "saludo" },
  children: ["Hola, Ana"]
}
```

React trabaja con estos objetos. Los guarda, los compara y decide qué cambiar en pantalla. Por eso un elemento es distinto de una cadena de HTML: es **dato estructurado**.

## De elemento a texto: renderToString

Para ver el resultado usamos `renderToString`, la misma idea que `react-dom/server`:

```js
const el = h("p", { id: "saludo" }, "Hola, Ana");
console.log(renderToString(el));
// <p id="saludo">Hola, Ana</p>
```

Tres detalles del mini React que verás en los ejercicios:

- Los hijos `false`, `null` y `undefined` no se dibujan. Significan «no muestres nada».
- Si `type` es una función, `renderToString` la ejecuta y pinta lo que devuelve. Así funcionan los componentes.
- El mini renderizador escribe las props con su nombre tal cual. En React real, `className` aparece en el HTML como `class`.

## Props: datos de entrada

Las **props** (propiedades) son los datos que llegan al elemento o al componente. En JSX se escriben como atributos:

```jsx
h("h1", { className: "titulo" }, "Mi página")
```

Las props son de solo lectura. El componente recibe datos y devuelve elementos. No decide cómo se guardan.

## Cómo se lee la entrada en los ejercicios

Cada plantilla ya trae el código que lee la entrada:

```js
const lineas = require("fs").readFileSync(0, "utf8")
  .split("\n").map((l) => l.trim()).filter((l) => l !== "");
```

`lineas[0]` es la primera línea escrita en la entrada. Tú solo completas la función marcada con `TODO`.

## Qué vas a practicar

- Escribir un componente que devuelve un elemento con `h`.
- Usar props para pasar datos al componente.
- Imprimir el resultado con `renderToString` y compararlo carácter a carácter con la salida esperada.
