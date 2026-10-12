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

function carritoReducer(carrito, accion) {
  if (accion.tipo === "añadir") {
    if (carrito.includes(accion.item)) return carrito;
    return [...carrito, accion.item];
  }
  if (accion.tipo === "quitar") {
    return carrito.filter((item) => item !== accion.item);
  }
  return carrito;
}

const lineas = require("fs").readFileSync(0, "utf8").split("\n").map((l) => l.trim()).filter((l) => l !== "");
const primera = lineas[0] || "";
const iniciales = primera === "" ? [] : primera.split(",");
const acciones = lineas.slice(1).map((l) => {
  const partes = l.split(" ");
  return { tipo: partes[0], item: partes.slice(1).join(" ") };
});
let carrito = iniciales;
for (const accion of acciones) {
  carrito = carritoReducer(carrito, accion);
}
console.log(JSON.stringify(carrito));
```

La idea: `includes` decide si hace falta cambiar; `[...carrito, item]` crea el array nuevo y `filter` crea el array sin el producto. En ningún caso se usa `push` sobre el carrito.
