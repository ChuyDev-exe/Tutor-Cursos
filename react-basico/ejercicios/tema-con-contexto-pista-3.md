La estructura es esta, sin la línea clave:

```js
function Etiqueta() {
  const tema = /* aquí */;
  return h("span", { className: tema }, "tema: " + tema);
}

function App({ inicial }) {
  const [tema, setTema] = useState(inicial);
  return h(/* aquí */, { value: tema }, h(Etiqueta, {}), h("button", /* ... */));
}
```