La estructura de App es esta, sin la línea clave:

```js
function App({ valor }) {
  const [n, setN] = useState(valor);
  return h(
    Fragmento,
    {},
    h(Lejano, {}),
    /* aquí */,
    h("button", { onClick: () => setN(n + 1) }, "sumar")
  );
}
```