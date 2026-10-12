# 7. useContext: estado compartido

## Objetivo

Al terminar este capítulo sabrás compartir datos entre muchos componentes con contexto, sin encadenar props.

## El problema de las props encadenadas

Imagina una app con tema claro u oscuro. El tema vive en `App`. Pero el botón de la barra y el texto del pie también lo necesitan.

Si todo se pasa con props, cada nivel intermedio repite el dato:

```js
h(Barra, { tema }, h(Navegacion, { tema }, h(Enlaces, { tema })))
```

`Navegacion` no usa `tema`; solo lo reenvía. A eso se le llama **prop drilling**: arrastrar props a través de componentes que no las usan. Con más niveles, el código se vuelve tedioso y frágil.

## createContext crea un contexto

El contexto es un canal para datos que muchos componentes necesitan. Se crea una vez, fuera de los componentes:

```js
const Tema = createContext("claro");
```

El valor entre paréntesis es el **valor por defecto**: lo que se lee si nadie publica otro. El resultado es un objeto con dos piezas: `Tema.Provider` y la función `useContext(Tema)`.

## Provider y consumidor

El **Provider** publica el valor. Cualquier componente debajo lo lee con **useContext**, sin recibir props:

```js
function App({ inicial }) {
  const [tema, setTema] = useState(inicial);
  return h(
    Tema.Provider,
    { value: tema },
    h(Etiqueta, {}),
    h("button", { onClick: () => setTema("oscuro") }, "cambiar")
  );
}

function Etiqueta() {
  const tema = useContext(Tema);
  return h("span", { className: tema }, "tema: " + tema);
}
```

`Etiqueta` no recibe ninguna prop. Lee el tema directamente del contexto. En el andamiaje, el Provider es transparente: no añade ninguna etiqueta al HTML.

## Provider anidado: gana el más cercano

Puedes anidar Providers del mismo contexto. Quien gana es el **más cercano** al consumidor:

```js
h(
  Tema.Provider,
  { value: "oscuro" },
  h(Tema.Provider, { value: "verde" }, h(Etiqueta, {}))
); // Etiqueta lee "verde"
```

Si no hay ningún Provider por encima, `useContext` devuelve el valor por defecto de `createContext`.

## Cuándo usar contexto

Usa contexto para datos que **muchos** componentes necesitan: tema, usuario, idioma, carrito. Para datos de una sola rama, sigue usando props. El contexto no sustituye a las props: solo elimina el traspaso intermedio.

## Ojo: el contexto no crea estado

El contexto transporta un valor; no guarda nada. El estado vive en el componente que publica el Provider y se actualiza con `useState`:

```js
const [tema, setTema] = useState("claro");
// el Provider recibe value={tema}; un botón llama a setTema
```

Cambiar el estado cambia el `value` del Provider. Todos los consumidores se redibujan con el valor nuevo.

## La gramática de eventos del andamiaje (repaso)

Los ejercicios de este capítulo usan el andamiaje con hooks. Recuerda:

- `ejecutar(Componente, props, eventos)` imprime **una línea por cada render**: el inicial y uno tras cada evento.
- Un evento `clic N` llama al N-ésimo `onClick` del árbol, en orden.
- Un evento `cambiar N texto` llama al N-ésimo `onChange` con `{ target: { value: texto } }`.
- Los mensajes de un `console.log` en un efecto aparecen después del HTML del render que lo disparó.

## Qué vas a practicar

- Crear un contexto con `createContext` y publicar un valor con `Provider`.
- Leer el valor con `useContext` sin pasar props.
- Comprobar que sin Provider se usa el valor por defecto.
- Actualizar el valor del contexto desde el estado con `useState`.
