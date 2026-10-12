La forma de la función es esta, sin la línea clave:

```js
function Contador() {
  const [n, setN] = useState(0);
  useEffect(() => {
    console.log("montado");
  }, [/* aquí */]);
  return h("div", {},
    h("p", {}, n),
    h("button", { onClick: () => setN((x) => x + 1) }, "sumar"));
}
```
