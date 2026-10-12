La forma de la función es esta, sin las líneas clave:

```js
function Resumen({ tareas }) {
  const [todas, setTodas] = useState(true);
  const hechas = tareas.filter((t) => t.hecha).length;
  const visibles = todas ? tareas : /* aquí */;
  return h("div", {},
    h("button", { onClick: () => setTodas(/* aquí */) }, "mostrar todas"),
    h("p", {}, "Hechas: " + hechas + " de " + tareas.length),
    h("ul", {}, ...visibles.map((t) =>
      h("li", { key: t.texto, className: /* aquí */ }, t.texto))));
}
```
