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

function diferencia(anterior, siguiente) {
  const añadidos = siguiente.filter((k) => !anterior.includes(k));
  const quitados = anterior.filter((k) => !siguiente.includes(k));
  const movidos = siguiente.filter(
    (k) => anterior.includes(k) && anterior.indexOf(k) !== siguiente.indexOf(k)
  );
  return { añadidos, quitados, movidos };
}

const crudas = require("fs").readFileSync(0, "utf8").split("\n");
const textoAnterior = (crudas[0] || "").trim();
const textoSiguiente = (crudas[1] || "").trim();
const anterior = textoAnterior === "" ? [] : textoAnterior.split(" ");
const siguiente = textoSiguiente === "" ? [] : textoSiguiente.split(" ");
const r = diferencia(anterior, siguiente);
console.log("añadidos:" + (r.añadidos.length ? " " + r.añadidos.join(" ") : ""));
console.log("quitados:" + (r.quitados.length ? " " + r.quitados.join(" ") : ""));
console.log("movidos:" + (r.movidos.length ? " " + r.movidos.join(" ") : ""));
```

La idea: tres `filter` independientes. `includes` decide si la key existe en la otra lista e `indexOf` compara la posición en cada una. El andamiaje imprime las tres líneas y deja vacía la parte después de los dos puntos cuando el array no tiene elementos.
