# 8. useMemo, useCallback y useRef

## Objetivo

Al terminar este capítulo sabrás memorizar valores y funciones, y guardar datos mutables con `useRef`.

## Por qué memorizar

Cada render recalcula todo el cuerpo del componente. En componentes pequeños no se nota. Pero si un cálculo es caro, o una función debe mantener la misma identidad entre renders, conviene memorizarlo.

**Memorizar** es guardar el resultado y reutilizarlo mientras las entradas no cambien.

## useMemo guarda un valor

`useMemo(() => valor, deps)` devuelve `valor`. Recalcula solo cuando una de las `deps` cambia:

```js
function Lista({ texto, items }) {
  const filtrados = useMemo(() => items.filter((t) => t.indexOf(texto) === 0), [texto, items]);
  return h("p", {}, String(filtrados.length));
}
```

Si `texto` e `items` no cambian, `filter` no se vuelve a ejecutar.

## useCallback guarda una función

`useCallback(() => fn, deps)` hace lo mismo, pero guarda la **función**: la misma referencia entre renders mientras `deps` no cambien.

```js
const sumar = useCallback(() => setN((x) => x + 1), []);
```

Útil cuando la función se pasa como prop a un componente memorizado, o cuando un efecto depende de su identidad.

## Deps correctas

Las `deps` deben incluir **todo** lo que el cálculo o la función usan.

- `[]` vacías: se calcula una sola vez, al montar. Puede quedar con datos viejos: es una **closure obsoleta**.
- Con las deps correctas: se recalcula justo cuando hace falta.

```js
// Ojo: lee tope de un render viejo
const sumar = useCallback(() => setN((x) => (x + 1 > tope ? x : x + 1)), []);

// Bien: recalcula cuando cambia tope
const sumar = useCallback(() => setN((x) => (x + 1 > tope ? x : x + 1)), [tope]);
```

## useRef: un objeto que persiste

`useRef(inicial)` devuelve un objeto `{ current: inicial }`. Ese objeto **persiste** entre renders y modificarlo **no** provoca redibujado.

```js
function Contador({ inicial }) {
  const [n, setN] = useState(inicial);
  const ref = useRef(null);
  const anterior = ref.current;
  ref.current = n;
  return h("p", {}, "actual: " + n);
}
```

Sirve para guardar el valor anterior, un id o un temporizador.

## React.memo evita renders de más

`React.memo(Componente)` compara las props del componente **superficialmente**. Si no cambian, React omite el render completo.

```js
const Fila = React.memo(function Fila({ nombre }) {
  return h("li", {}, nombre);
});
```

Si una prop es un objeto o función creado en cada render, la comparación siempre falla y memo no ayuda.

## Ojo: memorizar todo también cuesta

`useMemo` y `useCallback` guardan valores y crean comparaciones. Memoriza cuando hay una medición del problema: un cálculo lento o una identidad que cambia sin necesidad. No por defecto.

## Los hooks del andamiaje (repaso)

Los ejercicios de este capítulo usan el andamiaje con hooks. Ya disponibles: `useMemo`, `useCallback` y `useRef`, además de `useState` y `useEffect`.

- `ejecutar(Componente, props, eventos)` imprime una línea por cada render.
- Un evento `clic N` llama al N-ésimo `onClick` del árbol.
- Un evento `cambiar N texto` llama al N-ésimo `onChange` con `{ target: { value: texto } }`.
- Un `console.log` dentro de un efecto se imprime después del HTML del render que lo disparó.

## Qué vas a practicar

- Memorizar un filtro con `useMemo` y comprobar que el cálculo no se repite.
- Memorizar un manejador con `useCallback` y detectar sus cambios con un efecto.
- Guardar el valor anterior con `useRef` sin provocar renders extra.
