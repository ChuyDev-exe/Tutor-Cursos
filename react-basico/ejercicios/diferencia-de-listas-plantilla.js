// Diferencia de listas
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
function diferencia(anterior, siguiente) {
  // TODO: devuelve un objeto { añadidos, quitados, movidos } con tres arrays.
  // añadidos: claves de siguiente que no estaban en anterior, en orden de siguiente.
  // quitados: claves de anterior que ya no están en siguiente, en orden de anterior.
  // movidos:  claves de las dos listas cuya posición cambió, en orden de siguiente.
  // Arranque: los tres arrays vacíos.
  return { añadidos: [], quitados: [], movidos: [] };
}

// ── Entrada (andamiaje) ──────────────────────────────────────────
const crudas = require("fs").readFileSync(0, "utf8").split("\n");
const textoAnterior = (crudas[0] || "").trim();
const textoSiguiente = (crudas[1] || "").trim();
const anterior = textoAnterior === "" ? [] : textoAnterior.split(" ");
const siguiente = textoSiguiente === "" ? [] : textoSiguiente.split(" ");
const r = diferencia(anterior, siguiente);
console.log("añadidos:" + (r.añadidos.length ? " " + r.añadidos.join(" ") : ""));
console.log("quitados:" + (r.quitados.length ? " " + r.quitados.join(" ") : ""));
console.log("movidos:" + (r.movidos.length ? " " + r.movidos.join(" ") : ""));
