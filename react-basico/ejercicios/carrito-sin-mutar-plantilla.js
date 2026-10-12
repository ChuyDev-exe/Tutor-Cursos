// Carrito sin mutar
// Escribe aquí tu solución. El enunciado está en la vista del ejercicio.
// Usa la barra de estado: «Ejecutar código» y «Ejecutar pruebas».

// ── Mini React del curso (andamiaje: no lo modifiques) ────────────
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
// ──────────────────────────────────────────────────────────────────

function carritoReducer(carrito, accion) {
  // TODO: "añadir" → array nuevo con el producto al final, salvo que ya esté.
  //       "quitar" → array nuevo sin ese producto (filter).
  //       Nunca uses push: el array original no se modifica.
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
