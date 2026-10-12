// Tarjeta con children
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

function Tarjeta({ titulo, children }) {
  // TODO: devuelve un div con clase "tarjeta" que contiene:
  //   1) h("h2", { className: "titulo" }, titulo)
  //   2) h("div", { className: "cuerpo" }, ...children)
}

const lineas = require("fs").readFileSync(0, "utf8").split("\n").map((l) => l.trim()).filter((l) => l !== "");
const titulo = lineas[0] || "";
const parrafos = lineas.slice(1).map((t) => h("p", {}, t));
console.log(renderToString(h(Tarjeta, { titulo }, ...parrafos)));
