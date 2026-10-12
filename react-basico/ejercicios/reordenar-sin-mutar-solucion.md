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

function aplicar(lista, acciones) {
  let actual = lista;
  for (const accion of acciones) {
    if (accion.tipo === "añadir") {
      if (!actual.includes(accion.id)) actual = [...actual, accion.id];
    } else if (accion.tipo === "quitar") {
      actual = actual.filter((id) => id !== accion.id);
    } else if (accion.tipo === "subir") {
      const i = actual.indexOf(accion.id);
      if (i > 0) {
        const copia = actual.slice();
        const otro = copia[i - 1];
        copia[i - 1] = copia[i];
        copia[i] = otro;
        actual = copia;
      }
    } else if (accion.tipo === "bajar") {
      const i = actual.indexOf(accion.id);
      if (i !== -1 && i < actual.length - 1) {
        const copia = actual.slice();
        const otro = copia[i + 1];
        copia[i + 1] = copia[i];
        copia[i] = otro;
        actual = copia;
      }
    }
  }
  return actual;
}

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
```

La idea: cada acción reemplaza `actual` con un array nuevo, o lo deja igual si no hay cambio. `slice()` copia antes de intercambiar dos posiciones. La lista original nunca se toca, por eso la línea `original:` se imprime intacta.
