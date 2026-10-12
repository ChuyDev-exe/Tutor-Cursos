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

function Tarjeta({ titulo, children }) {
  return h(
    "div",
    { className: "tarjeta" },
    h("h2", { className: "titulo" }, titulo),
    h("div", { className: "cuerpo" }, ...children)
  );
}

const lineas = require("fs").readFileSync(0, "utf8").split("\n").map((l) => l.trim()).filter((l) => l !== "");
const titulo = lineas[0] || "";
const parrafos = lineas.slice(1).map((t) => h("p", {}, t));
console.log(renderToString(h(Tarjeta, { titulo }, ...parrafos)));
```

La idea: `children` es un array con los párrafos. El `...` lo expande dentro del `div` de clase `cuerpo`. El componente no sabe cuántos párrafos llegan: solo los coloca.
