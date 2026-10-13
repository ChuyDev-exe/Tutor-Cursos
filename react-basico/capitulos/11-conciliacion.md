# 11. Conciliación: cómo React actualiza la interfaz

## Objetivo

Al terminar este capítulo sabrás cómo React decide qué cambiar en el DOM y cuándo medir el rendimiento.

## Renderizar barato, actualizar caro

Cada render de React tiene dos pasos. Primero dibuja un árbol de elementos nuevo con `h(...)`. Después decide qué cambiar en el DOM real.

Dibujar el árbol es barato: son objetos en memoria. Escribir en el DOM es caro. Por eso React calcula un árbol nuevo en cada render sin notarse.

```js
const arbol = h("ul", {}, h("li", { key: "a" }, "a"));
```

Este código solo crea un objeto con `type`, `props` y `children`. No toca la página.

## El DOM virtual y la comparación

El árbol de objetos se llama **DOM virtual**. En cada render React guarda el árbol anterior y el nuevo. A esa comparación se le llama **conciliación**.

La comparación sigue reglas fijas:

1. Si el `type` cambia, React elimina el nodo viejo y crea uno nuevo.
2. Si el `type` es igual, React conserva el nodo del DOM y solo actualiza las props cambiadas.
3. Si un elemento ya no está en el árbol nuevo, React elimina su nodo.

```js
// type igual: React conserva el div y solo cambia el texto
h("div", {}, "uno");
h("div", {}, "dos");
```

El nodo `div` se queda donde está. Solo cambia su contenido. Así se conserva el foco.

## Las keys en la conciliación

En una lista, sin `key` React compara los hijos **por posición**. Si añades un elemento al principio, todas las posiciones se desplazan y React puede recrear nodos intactos.

Con `key` estables React identifica cada hijo entre un render y el siguiente:

```js
items.map((t) => h("li", { key: t }, t));
```

Con keys, React sabe quién es quién: detecta añadidos, quitados y reordenados, y reconstruye solo lo necesario.

Una buena key es estable, es única dentro de la lista y no suele ser el índice. El índice cambia al reordenar.

## React.memo y PureComponents

`React.memo(Componente)` compara las props del componente con una **comparación superficial**. Si no cambian, React omite el render completo.

```js
const Fila = React.memo(function Fila({ nombre }) {
  return h("li", {}, nombre);
});
```

La comparación superficial mira cada prop con `Object.is`. No entra dentro de los objetos ni de los arrays.

Conviene cuando el componente es caro o se repite con las mismas props. No conviene cuando las props cambian siempre: un objeto o función creado en cada render falla la comparación siempre. Tampoco conviene en componentes pequeños, porque la comparación cuesta tanto como el render.

`PureComponent` es la misma idea en componentes de clase: compara props y estado antes de pintar.

## Renders innecesarios y buenas prácticas

Un **render innecesario** es un pintado que no cambia nada visible. Errores típicos:

- Usar el índice como key: al reordenar, los datos viejos quedan en filas nuevas.
- Crear una función nueva en cada render para un hijo con `React.memo`.
- Mutar el estado: si la referencia no cambia, React no vuelve a pintar.
- Escribir en el DOM a mano: el siguiente render lo sobrescribe.

Buenas prácticas: keys estables, medir antes de optimizar y actualizar el estado con valores nuevos.

## Errores y límites

Un **límite de errores** (error boundary) es un componente de clase que captura errores de render. Muestra un respaldo en lugar de dejar la pantalla en blanco.

```js
class Limite extends React.Component {
  state = { error: null };

  static getDerivedStateFromError(error) {
    return { error };
  }

  render() {
    if (this.state.error) return h("p", {}, "Algo falló");
    return this.props.children;
  }
}
```

`getDerivedStateFromError` guarda el error. `componentDidCatch` se usa para registrar el fallo.

Un límite de errores no captura errores de eventos, de callbacks y promesas, ni los del propio límite.

## Renderizado diferido

React 18 permite priorizar actualizaciones con `startTransition`:

```js
import { startTransition } from "react";

startTransition(() => setLista(listaLarga));
```

La actualización marcada como **transición** es de baja prioridad. React atiende antes lo urgente. `useTransition` ofrece lo mismo como hook: `[enTransicion, empezar]`.

**Suspense** con `React.lazy` pospone el render de un componente hasta que está listo:

```js
const Pesado = React.lazy(() => import("./Pesado"));
h(Suspense, { fallback: h("p", {}, "Cargando...") }, h(Pesado));
```

Mientras carga, se muestra el `fallback`.

## Cuándo preocuparte por el rendimiento

| Situación | ¿Preocuparte? |
| --- | --- |
| Lista pequeña, menos de 100 filas | No |
| Cálculo caro repetido en cada render | Sí |
| Lista larga que se reordena a menudo | Sí |
| Hijo memorizado con objetos nuevos cada render | Sí |

## El andamiaje de estos ejercicios

Los ejercicios de este capítulo no usan hooks ni eventos. Usan el mini React básico del curso: `h(type, props, ...children)` crea un elemento y `renderToString(elemento)` lo convierte en una cadena de texto con HTML.

Cada plantilla ya trae esas dos herramientas. Tu trabajo es escribir una función pura. La sección de entrada ya lee la entrada estándar, parsea las líneas de datos, llama a tu función y escribe el resultado. No hay eventos: la entrada son solo datos.

## Qué vas a practicar

- Calcular qué cambia entre dos listas de keys: añadidos, quitados y movidos.
- Reordenar una lista devolviendo arrays nuevos, sin mutar el original.
- Comparar dos objetos de props al estilo de `React.memo`.
- Releer la teoría de conciliación, keys, memo, límites de errores y transiciones.
