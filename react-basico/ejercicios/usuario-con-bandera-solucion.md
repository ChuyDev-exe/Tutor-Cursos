```js
const h = (type, props, ...children) => ({
  type,
  props: props || {},
  children: children.flat(Infinity).filter((c) => c !== null && c !== undefined && c !== false),
});

function renderToString(node) {
  if (node === null || node === undefined || node === false) return "";
  if (typeof node === "string" || typeof node === "number") return String(node);
  if (typeof node.type === "function") {
    return renderToString(node.type({ ...node.props, children: node.children }));
  }
  const attrs = Object.entries(node.props)
    .filter(([k, v]) => k !== "children" && v !== false && v !== null && v !== undefined)
    .map(([k, v]) => ` ${k}="${v === true ? "" : v}"`)
    .join("");
  const inner = node.children.map(renderToString).join("");
  return `<${node.type}${attrs}>${inner}</${node.type}>`;
}

function Usuario({ nombre, activo }) {
  const className = activo ? "usuario activo" : "usuario";
  return h("li", { className }, nombre);
}

const lineas = require("fs").readFileSync(0, "utf8").split("\n").map((l) => l.trim()).filter((l) => l !== "");
const nombre = lineas[0] || "";
const activo = lineas[1] === "true";
console.log(renderToString(h(Usuario, { nombre, activo })));
```

La idea: el ternario `activo ? … : …` elige el valor de la prop `className`. El resto del componente es igual en los dos casos: misma etiqueta, mismo contenido.
