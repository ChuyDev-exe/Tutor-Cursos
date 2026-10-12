La estructura es esta, sin la línea clave:

```js
function Contador({ inicial }) {
  const [n, setN] = useState(inicial);
  const ref = useRef(null);
  const anterior = /* aquí, con "-" si current es null */;
  /* aquí */;
  return h(
    "div",
    {},
    h("p", {}, "actual: " + n + " · anterior: " + anterior),
    h("button", { onClick: () => setN(n + 1) }, "sumar")
  );
}
```