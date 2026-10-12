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

function Lista({ items }) {
  const elementos = items.map((texto) => h("li", { key: texto }, texto));
  return h("ul", {}, ...elementos);
}

const lineas = require("fs").readFileSync(0, "utf8").split("\n").map((l) => l.trim()).filter((l) => l !== "");
const primera = lineas[0] || "";
const items = primera === "" ? [] : primera.split(" ");
console.log(renderToString(h(Lista, { items })));
```

La idea: `map` transforma cada texto en un elemento `li` con su `key`. El `...` expande el resultado dentro de `ul`. Si `items` está vacío, `map` devuelve `[]` y `ul` sale sin contenido.
