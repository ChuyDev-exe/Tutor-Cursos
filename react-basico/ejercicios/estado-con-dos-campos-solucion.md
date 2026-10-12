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

function reducer(estado, accion) {
  if (accion.tipo === "subir") return { ...estado, contador: estado.contador + 1 };
  if (accion.tipo === "bajar") return { ...estado, contador: estado.contador - 1 };
  if (accion.tipo === "fijar") return { ...estado, contador: accion.valor };
  if (accion.tipo === "alternar") return { ...estado, visible: !estado.visible };
  return estado;
}

const lineas = require("fs").readFileSync(0, "utf8").split("\n").map((l) => l.trim()).filter((l) => l !== "");
const estadoInicial = { contador: Number(lineas[0] || "0"), visible: true };
const acciones = lineas.slice(1).map((l) => {
  const partes = l.split(" ");
  return partes.length === 1 ? { tipo: partes[0] } : { tipo: partes[0], valor: Number(partes[1]) };
});
let estado = estadoInicial;
for (const accion of acciones) {
  estado = reducer(estado, accion);
}
console.log(`${estado.contador} ${estado.visible}`);
```

La idea: cada acción devuelve un objeto nuevo con `{ ...estado, campo: valor }`. La copia superficial conserva los campos que no cambian, así `visible` se mantiene mientras solo se toca el contador.
