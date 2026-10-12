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

function Etiqueta({ texto, tipo }) {
  return h(tipo, { className: "etiqueta" }, texto);
}

const lineas = require("fs").readFileSync(0, "utf8").split("\n").map((l) => l.trim()).filter((l) => l !== "");
const partes = (lineas[0] || "").split(" ");
const tipo = partes[0];
const texto = partes.slice(1).join(" ");
console.log(renderToString(h(Etiqueta, { tipo, texto })));
```

La idea: el tipo de etiqueta no está escrito a mano, llega como prop y se usa como primer argumento de `h`. Así un mismo componente sirve para `span`, `h2` o `p`.
