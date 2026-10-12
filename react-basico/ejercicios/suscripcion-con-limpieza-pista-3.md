La forma de la función es esta, sin las líneas clave:

```js
function Conexion() {
  const [conectado, setConectado] = useState(false);
  useEffect(() => {
    if (conectado) {
      console.log("conectado");
      return /* aquí */;
    }
    console.log("desconectado");
  }, [conectado]);
  return h("div", {},
    h("p", {}, conectado ? "si" : "no"),
    h("button", { onClick: () => setConectado(/* aquí */) }, "alternar"));
}
```
