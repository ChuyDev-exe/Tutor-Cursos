// Comparar props
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

// ── Tu solución ───────────────────────────────────────────────────
function iguales(a, b) {
  // TODO: comparación superficial al estilo React.memo.
  // Misma cantidad de claves y Object.is en cada valor → "si".
  // Falta una clave, sobra una o cambia un valor → "no".
  return "no";
}

// ── Entrada (andamiaje) ──────────────────────────────────────────
function parsearProps(linea) {
  const objeto = {};
  const trozos = linea.trim() === "" ? [] : linea.trim().split(" ");
  for (const trozo of trozos) {
    const corte = trozo.indexOf("=");
    const clave = corte === -1 ? trozo : trozo.slice(0, corte);
    const valor = corte === -1 ? "" : trozo.slice(corte + 1);
    objeto[clave] = valor;
  }
  return objeto;
}

const crudas = require("fs").readFileSync(0, "utf8").split("\n");
const anteriores = parsearProps(crudas[0] || "");
const siguientes = parsearProps(crudas[1] || "");
console.log(iguales(anteriores, siguientes));
