// Reordenar sin mutar
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
function aplicar(lista, acciones) {
  // TODO: "añadir id" → array nuevo con el id al final, salvo que ya esté.
  //       "quitar id" → array nuevo sin ese id (filter).
  //       "subir id"  → copia nueva intercambiando el id con el anterior.
  //       "bajar id"  → copia nueva intercambiando el id con el siguiente.
  // Nunca uses push, splice ni sort sobre la lista original.
  return lista;
}

// ── Entrada (andamiaje) ──────────────────────────────────────────
const crudas = require("fs").readFileSync(0, "utf8").split("\n");
const primera = (crudas[0] || "").trim();
const iniciales = primera === "" ? [] : primera.split(" ");
const acciones = crudas
  .slice(1)
  .map((l) => l.trim())
  .filter((l) => l !== "")
  .map((l) => {
    const partes = l.split(" ");
    return { tipo: partes[0], id: partes.slice(1).join(" ") };
  });
const resultado = aplicar(iniciales, acciones);
console.log("original:" + (iniciales.length ? " " + iniciales.join(" ") : ""));
console.log("lista:" + (resultado.length ? " " + resultado.join(" ") : ""));
