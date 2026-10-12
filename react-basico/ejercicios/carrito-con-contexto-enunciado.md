# Carrito con contexto

Comparte un carrito entre varios componentes. Cada `Producto` tiene un botón que añade su nombre; `VerCarrito` muestra los items leyendo el contexto, sin recibir props.

El contexto es `Carrito = createContext({ items: [], anadir: () => {} })`. El Provider de `App` publica `{ items, anadir }`. La función `anadir` agrega un producto sin mutar el array, con spread.

## Entrada

1. La primera línea: los productos separados por espacio. Si está vacía, no hay productos.
2. Las siguientes son eventos:
   - `clic N` → pulsa el botón del producto N-ésimo (1-based, en orden del árbol).

## Salida

Una línea por cada render, en este orden:

- El `<p>` de `VerCarrito`: `carrito: pan, leche` o `carrito: vacio` si no hay items.
- Después, un `<button>` por producto: `añadir pan`, `añadir leche`…

## Ejemplo

Entrada:
```
pan leche
clic 2
```

Salida:
```
<p>carrito: vacio</p><button>añadir pan</button><button>añadir leche</button>
<p>carrito: leche</p><button>añadir pan</button><button>añadir leche</button>
```
