```js
// Hook useLista
// Escribe aquí tu solución. El enunciado está en la vista del ejercicio.
// Usa la barra de estado: «Ejecutar código» y «Ejecutar pruebas».

// ── Mini React del curso (andamiaje: no lo modifiques) ────────────
const Fragmento = Symbol("fragmento");

const h = (type, props, ...children) => ({
  type,
  props: props || {},
  children: children.flat(Infinity).filter((c) => c !== null && c !== undefined && c !== false),
});

function renderToString(node) {
  if (node === null || node === undefined || node === false) return "";
  if (typeof node === "string" || typeof node === "number") return String(node);
  if (node.type === Fragmento) return node.children.map(renderToString).join("");
  if (typeof node.type === "function") {
    return renderToString(node.type({ ...node.props, children: node.children }));
  }
  const attrs = Object.entries(node.props)
    .filter(([k, v]) => k !== "children" && typeof v !== "function" && v !== false && v !== null && v !== undefined)
    .map(([k, v]) => ` ${k}="${v === true ? "" : v}"`)
    .join("");
  const inner = node.children.map(renderToString).join("");
  return `<${node.type}${attrs}>${inner}</${node.type}>`;
}

// ── Memoria de hooks de la instancia ──
let hooks = [];
let indice = 0;
let pendientes = [];
let marcado = false;

function useState(inicial) {
  const i = indice++;
  if (!hooks[i]) hooks[i] = { valor: typeof inicial === "function" ? inicial() : inicial };
  const valor = hooks[i].valor;
  const set = (v) => {
    const nuevo = typeof v === "function" ? v(valor) : v;
    if (!Object.is(nuevo, hooks[i].valor)) {
      hooks[i].valor = nuevo;
      marcado = true;
    }
  };
  return [valor, set];
}

function depsCambian(previo, deps) {
  if (!previo) return true;
  if (deps === undefined) return true;
  if (deps.length === 0) return false;
  return deps.some((d, k) => !Object.is(d, previo.deps[k]));
}

function useEffect(efecto, deps) {
  const i = indice++;
  const previo = hooks[i];
  const cambia = depsCambian(previo, deps);
  hooks[i] = { deps, limpieza: previo ? previo.limpieza : null };
  if (cambia) pendientes.push({ i, efecto });
}

function useMemo(fn, deps) {
  const i = indice++;
  const previo = hooks[i];
  if (depsCambian(previo, deps)) hooks[i] = { deps, valor: fn() };
  else hooks[i].deps = deps;
  return hooks[i].valor;
}

function useCallback(fn, deps) {
  const i = indice++;
  const previo = hooks[i];
  if (depsCambian(previo, deps)) hooks[i] = { deps, valor: fn };
  else hooks[i].deps = deps;
  return hooks[i].valor;
}

function useRef(inicial) {
  const i = indice++;
  if (!hooks[i]) hooks[i] = { valor: { current: inicial } };
  return hooks[i].valor;
}

function createContext(inicial) {
  const pila = [];
  function Provider({ children }) {
    return h(Fragmento, {}, ...children);
  }
  Provider.__pila = pila;
  return { Provider, inicial, pila };
}

function useContext(contexto) {
  return contexto.pila.length ? contexto.pila[contexto.pila.length - 1] : contexto.inicial;
}

// ── Expansión y eventos ──
function expandir(nodo) {
  if (nodo === null || nodo === undefined || nodo === false) return null;
  if (typeof nodo === "string" || typeof nodo === "number") return nodo;
  if (typeof nodo.type === "function") {
    const salida = nodo.type({ ...nodo.props, children: nodo.children });
    const pila = nodo.type.__pila;
    if (pila) {
      pila.push(nodo.props.value);
      try {
        return expandir(salida);
      } finally {
        pila.pop();
      }
    }
    return expandir(salida);
  }
  return {
    ...nodo,
    children: nodo.children.map(expandir).filter((c) => c !== null && c !== undefined && c !== false),
  };
}

function buscarPropios(nodo, nombre, fuera) {
  if (!nodo || typeof nodo !== "object") return fuera;
  if (nodo.props && typeof nodo.props[nombre] === "function") fuera.push(nodo.props[nombre]);
  for (const hijo of nodo.children || []) buscarPropios(hijo, nombre, fuera);
  return fuera;
}

function parsearEventos(lineas) {
  return lineas.map((l) => {
    if (l === "clic" || l.indexOf("clic ") === 0) {
      const partes = l.split(" ");
      return { tipo: "clic", indice: Number(partes[1] || "1") };
    }
    if (l.indexOf("cambiar ") === 0) {
      const resto = l.slice(8);
      const espacio = resto.indexOf(" ");
      if (espacio === -1) return { tipo: "cambiar", indice: Number(resto), valor: "" };
      return { tipo: "cambiar", indice: Number(resto.slice(0, espacio)), valor: resto.slice(espacio + 1) };
    }
    throw new Error("línea de evento desconocida: " + l);
  });
}

function ejecutar(Componente, props, eventos) {
  hooks = [];
  indice = 0;
  pendientes = [];
  marcado = false;
  let raiz = null;
  const renderYPublicar = () => {
    let vueltas = 0;
    do {
      marcado = false;
      indice = 0;
      pendientes = [];
      raiz = expandir(h(Componente, props));
      const lista = pendientes;
      pendientes = [];
      console.log(renderToString(raiz));
      for (const e of lista) {
        const reg = hooks[e.i];
        if (reg.limpieza) reg.limpieza();
        const limpieza = e.efecto();
        reg.limpieza = typeof limpieza === "function" ? limpieza : null;
      }
      vueltas++;
    } while (marcado && vueltas < 20);
  };
  renderYPublicar();
  for (const ev of eventos) {
    if (ev.tipo === "clic") {
      const manejadores = buscarPropios(raiz, "onClick", []);
      const f = manejadores[ev.indice - 1];
      if (f) f({ type: "click" });
    } else if (ev.tipo === "cambiar") {
      const manejadores = buscarPropios(raiz, "onChange", []);
      const f = manejadores[ev.indice - 1];
      if (f) f({ target: { value: ev.valor } });
    }
    renderYPublicar();
  }
}
// ──────────────────────────────────────────────────────────────────

// ── Tu solución ────────────────────────────────────────────────

function useLista(inicial) {
  const [items, setItems] = useState(inicial);
  const agregar = (x) => setItems((prev) => (prev.includes(x) ? prev : [...prev, x]));
  const quitar = (x) => setItems((prev) => prev.filter((i) => i !== x));
  return { items, agregar, quitar };
}

// ── Componente (no lo modifiques) ──────────────────────────────

function Lista({ inicial }) {
  const { items, agregar, quitar } = useLista(inicial);
  return h("div", {},
    h("ul", {}, ...items.map((x) => h("li", { key: x }, x))),
    h("button", { onClick: () => agregar("pan") }, "agregar pan"),
    h("button", { onClick: () => quitar("pan") }, "quitar pan"),
    h("button", { onClick: () => agregar("agua") }, "agregar agua")
  );
}

// ── Entrada (andamiaje) ────────────────────────────────────────

const lineas = require("fs").readFileSync(0, "utf8").split("\n").map((l) => l.trim());
if (lineas.length && lineas[lineas.length - 1] === "") lineas.pop();
const inicial = (lineas[0] || "").split(" ").filter((x) => x !== "");
const eventos = parsearEventos(lineas.slice(1));
ejecutar(Lista, { inicial }, eventos);
```

El hook guarda el array en useState y devuelve objeto con los tres miembros. agregar usa actualización funcional: si el elemento ya está devuelve el mismo array; si no, uno nuevo con spread. quitar siempre devuelve un array nuevo con filter.
