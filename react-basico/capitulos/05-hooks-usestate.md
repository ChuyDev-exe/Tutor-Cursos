# 5. Hooks: reglas y useState

## Objetivo

Al terminar este capítulo sabrás usar `useState`: sus reglas, las actualizaciones funcionales, el estado con objeto y los valores derivados.

## Qué es un hook

Un **hook** es una función especial de React. Empieza por `use` y permite usar estado u otras capacidades dentro de un componente.

`useState` es el hook del estado. Se llama al principio del componente:

```js
function Contador() {
  const [n, setN] = useState(0);
  return h("button", { onClick: () => setN(1) }, String(n));
}
```

La primera vez guarda el valor `0`. Ese valor se conserva entre renders.

## Las reglas de los hooks

Dos reglas, y son obligatorias:

1. Llama a los hooks siempre en el mismo orden.
2. Nunca los pongas dentro de un `if`, de un bucle ni de una función anidada.

React guarda cada hook por su posición. Si el orden cambia, React lee el valor equivocado. Los hooks solo se llaman en componentes de React o en otros hooks.

## useState devuelve un par

`useState` devuelve un array con dos posiciones: el valor actual y la función de actualización.

```js
const [n, setN] = useState(0);
setN(5);
```

`setN` no cambia `n` en el sitio. Guarda el valor nuevo y pide un render. React redibuja el componente con el valor nuevo.

## Actualizaciones funcionales

Cuando el nuevo valor depende del anterior, pasa una función a `setN`:

```js
setN((x) => x + 1);
```

La función recibe el valor anterior y devuelve el siguiente. Dos clics seguidos producen tres renders:

```
<p>0</p>
<p>1</p>
<p>2</p>
```

La forma funcional no depende del valor que ves en el render. Por eso es la forma segura de sumar o restar.

## Estado con objeto

El estado puede ser un objeto con varios campos. Nunca se muta: se copia con spread.

```js
const [estado, setEstado] = useState({ n: 0, veces: 0 });
setEstado((e) => ({ ...e, n: e.n + 1 }));
```

`{ ...e }` copia los campos del objeto anterior. El campo `n` cambia y el campo `veces` se conserva.

## Valor derivado

Un **valor derivado** se calcula a partir del estado, en cada render. No se guarda en el estado.

```js
const hechas = tareas.filter((t) => t.hecha).length;
```

Si guardaras `hechas`, tendrías dos datos que pueden desincronizarse. El conteo se calcula mientras renderizas.

## Cómo se ejecuta el código en los ejercicios

Los ejercicios de este capítulo usan el andamiaje con hooks:

- `ejecutar(Componente, props, eventos)` imprime una línea por cada render.
- El primer render se imprime siempre, antes de los eventos.
- Tras cada evento se imprime un render más.
- `parsearEventos(lineas)` lee las líneas de eventos.
- `clic` o `clic N` llama al N-ésimo `onClick` encontrado en el árbol.
- `cambiar N texto` llama al N-ésimo `onChange` con `{ target: { value: texto } }`.

## Qué vas a practicar

- Escribir un contador con `useState` y actualizaciones funcionales.
- Actualizar un objeto de estado con spread, sin mutarlo.
- Calcular los conteos en cada render con variables derivadas.
