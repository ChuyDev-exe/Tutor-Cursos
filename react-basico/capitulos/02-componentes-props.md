# 2. Componentes, props y composición

## Objetivo

Al terminar este capítulo sabrás escribir componentes que reciben datos, combinan otros componentes y renderizan contenido de forma condicional.

## Un componente es una función

Un componente de React es una función que recibe props y devuelve un elemento:

```js
function Saludo({ nombre }) {
  return h("p", {}, "Hola, " + nombre);
}
```

Para usarlo se pasa la función como tipo de `h`:

```js
renderToString(h(Saludo, { nombre: "Ana" }));
// <p>Hola, Ana</p>
```

`renderToString` detecta que `type` es una función, la llama con las props y pinta lo que devuelve. Esa es toda la mecánica.

## El objeto props

Las props llegan en un objeto. El `{ nombre }` del ejemplo es una forma corta de extraer la propiedad `nombre` del objeto que llega:

```js
function Etiqueta({ texto, tipo }) {
  return h(tipo, { className: "etiqueta" }, texto);
}
```

Las props son de solo lectura. El componente no las cambia. Si necesita datos diferentes, los recibe por otra prop o los calcula con estado (capítulo 3).

## Composición: componentes dentro de componentes

Un componente puede devolver elementos que contienen a otros componentes. Así se construye una interfaz: piezas pequeñas que se ensamblan.

```js
function Tarjeta({ titulo }) {
  return h("div", { className: "tarjeta" },
    h("h2", { className: "titulo" }, titulo));
}
```

La regla de oro: cada componente hace una cosa y la hace bien. El padre organiza; el hijo detalla.

## children: el contenido que envuelve

Cuando escribes elementos dentro de un componente, esos hijos llegan en la prop especial `children`:

```js
function Cuerpo({ children }) {
  return h("div", { className: "cuerpo" }, ...children);
}
```

`children` es un array. El `...` (operador de expansión) lo deshace para que cada elemento quede como hijo de la etiqueta.

## Renderizado condicional

A veces un elemento se muestra y a veces no. Tres formas habituales:

```js
// 1. Ternario
return h("li", { className: activo ? "usuario activo" : "usuario" }, nombre);

// 2. operador &&
return activo ? h("span", {}, "en línea") : h("span", {}, "fuera");

// 3. if fuera del return
if (!activo) return h("li", { className: "usuario" }, nombre);
```

El mini React también entiende que `false`, `null` y `undefined` no se dibujan. Puedes devolver «nada» y la interfaz queda vacía.

## Qué vas a practicar

- Escribir un componente con varias props.
- Usar un ternario para cambiar la clase de una etiqueta.
- Recibir `children` y colocarlos dentro de una etiqueta contenedora.
