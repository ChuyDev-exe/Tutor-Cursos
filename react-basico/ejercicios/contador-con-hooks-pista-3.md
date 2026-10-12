La forma de la función es esta, sin la línea clave:

```js
function Contador({ inicial }) {
  const [n, setN] = useState(inicial);
  return h("div", {},
    h("p", {}, n),
    h("button", { onClick: () => setN(/* aquí */) }, "sumar"),
    h("button", { onClick: () => setN(/* aquí */) }, "restar"));
}
```
