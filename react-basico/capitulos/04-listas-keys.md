# 4. Listas, keys e inmutabilidad

## Objetivo

Al terminar este capítulo sabrás renderizar arrays de elementos, darles `key` y actualizar listas sin mutar el array original.

## Renderizar una lista con map

Las interfaces muestran muchas listas. En React se crea una lista transformando datos con `map`:

```js
const items = ["perro", "gato"];
const elementos = items.map((texto) => h("li", { key: texto }, texto));
console.log(renderToString(h("ul", {}, ...elementos)));
// <ul><li key="perro">perro</li><li key="gato">gato</li></ul>
```

`map` recorre el array y devuelve un array nuevo de elementos. El `...` los expande dentro de `h("ul", ...)`. Si el array está vacío, no hay hijos y el resultado es `<ul></ul>`.

## Qué es key y por qué importa

`key` es una prop especial. React la usa para identificar cada elemento **entre un render y el siguiente**. Con una key estable sabe quién es quién: qué se movió, qué cambió y qué desapareció.

Sin keys, React recurre a la posición del elemento. Si la lista se reordena, puede pintar los datos equivocados en cada fila.

Buenas prácticas:

- Usa un identificador estable del propio dato: el texto, el id.
- Evita repetir la misma key dentro de una misma lista.
- La key no se muestra como contenido: es una etiqueta interna de React. El mini React de este curso la escribe en el HTML para que puedas verla.

## Actualizar una lista sin mutarla

El mismo principio del capítulo anterior vale doble en las listas: **nunca hagas push ni splices sobre el array del estado**.

```js
// No: modifica el array original
carrito.push("pan");

// Sí: array nuevo
const nuevo = [...carrito, "pan"];
```

Métodos que devuelven array nuevo: `map`, `filter` y `slice`. El que muta es `push`.

## Quitar elementos con filter

Para eliminar se filtra y se guarda el resultado:

```js
const sinPan = carrito.filter((item) => item !== "pan");
```

`filter` deja el original igual. Si el elemento no existía, el resultado es el mismo contenido (aunque sea un array distinto).

## Reglas de un reducer de listas

Un reducer que gobierna una lista sigue estas pautas:

1. **Añadir**: `[...lista, nuevo]`, o devolver la misma lista si ya estaba.
2. **Quitar**: `lista.filter(...)`.
3. **Ordenar**: `lista.slice().sort(...)` sobre una copia.
4. Siempre devolver un array: nuevo o el mismo, nunca `undefined`.

## Qué vas a practicar

- Convertir una lista de textos en elementos `<li>` con `key`.
- Añadir y quitar elementos con spread y filter.
- Confirmar con las pruebas que el array original no cambió.
