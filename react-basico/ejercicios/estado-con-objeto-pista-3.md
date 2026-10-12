La forma de la función es esta, sin las líneas clave:

```js
function Contador({ inicial }) {
  const [estado, setEstado] = useState({ n: inicial, veces: 0 });
  return h("div", {},
    h("p", {}, "n: " + estado.n),
    h("p", {}, "veces: " + estado.veces),
    h("button", { onClick: () => setEstado((e) => ({ ...e, /* aquí */ })) }, "sumar"),
    h("button", { onClick: () => setEstado((e) => ({ ...e, /* aquí */ })) }, "reiniciar"));
}
```
