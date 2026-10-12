La estructura de App es esta, sin la línea clave:

```js
function App({ productos }) {
  const [items, setItems] = useState([]);
  const anadir = (nombre) => /* aquí */;
  const lista = productos.map((nombre, i) => h(Producto, { key: "p" + i, nombre, indice: i }));
  return h(/* aquí */, { value: { items, anadir } }, h(VerCarrito, {}), ...lista);
}
```