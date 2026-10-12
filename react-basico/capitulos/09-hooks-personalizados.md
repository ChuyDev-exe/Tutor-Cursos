# 9. Hooks personalizados

## Objetivo

Al terminar este capítulo sabrás extraer lógica con estado en tus propios hooks y reutilizarla en varios componentes.

## Qué es un hook personalizado

Un **hook personalizado** es una función que usa otros hooks. No es una API de React: es un patrón que tú creas.

El nombre empieza por `use`. Así React y las herramientas reconocen que dentro hay hooks.

```js
function useContador(inicial) {
  const [n, setN] = useState(inicial);
  return n;
}
```

`useContador` llama a `useState` y entrega el número guardado. Cualquiera puede llamarla dentro de un componente.

## Para qué sirve

Muchos componentes repiten la misma lógica: un contador, un texto con su manejador, una lista con agregar y quitar.

Sin hooks personalizados, copias el `useState` y los manejadores en cada sitio. Con un hook, escribes la lógica una vez.

```js
function useContador(inicial) {
  const [n, setN] = useState(inicial);
  const sumar = () => setN((x) => x + 1);
  const restar = () => setN((x) => x - 1);
  return { n, sumar, restar };
}
```

El hook reúne el estado y las dos funciones. Dos componentes distintos pueden usarlo sin copiar nada.

## Reglas de los hooks personales

Las reglas de React también aplican a tus hooks:

1. Llámalos dentro de componentes o de otros hooks personalizados.
2. Llámalos siempre en el mismo orden, al principio de la función.
3. Nunca dentro de un `if`, un `for` ni después de un `return`.

Si rompes una regla, React pierde la correspondencia entre hooks y renders.

## Qué devuelve un hook

Un hook personalizado devuelve lo que su consumidor necesita. Lo habitual es un objeto:

```js
return { n, sumar, restar, poner };
```

El objeto se lee bien con desestructuración: `const { n, sumar } = useContador(0)`. También puedes devolver una tupla, como hace `useState`. El objeto suele leerse mejor.

## Un hook no es un componente

El componente devuelve JSX. El hook devuelve datos y funciones.

```js
function Contador({ inicial }) {
  const { n, sumar } = useContador(inicial);
  return h("p", { onClick: sumar }, n);
}
```

`useContador` no dibuja nada. `Contador` decide cómo se ve el contador en pantalla.

## El andamiaje del curso

Los ejercicios de este capítulo usan el andamiaje con hooks. Estas son sus herramientas:

- `ejecutar(Componente, props, eventos)` imprime **una línea por cada render**: el inicial y uno tras cada evento.
- `clic N` llama al N-ésimo `onClick` del árbol, contando en orden de aparición.
- `cambiar N texto` llama al N-ésimo `onChange` con `{ target: { value: texto } }`. El texto puede contener espacios.
- Hay `useState`, `useEffect`, `useMemo`, `useCallback`, `useRef` y contexto, además de `h` y `renderToString`.

Si un botón no cambia el estado, el render se imprime igual y repite la misma línea. Así ves que el evento llegó.

## Qué vas a practicar

- Escribir `useContador`, `useLista` y `useCampo` con `useState`.
- Devolver un objeto con el estado y sus manejadores.
- Actualizar sin mutar: spread para añadir, filter para quitar.
- Confirmar cada cambio mirando los renders que imprime `ejecutar`.
