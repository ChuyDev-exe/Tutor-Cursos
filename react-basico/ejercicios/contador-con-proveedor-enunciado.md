# Contador con proveedor

Comprueba qué pasa cuando un consumidor está dentro del Provider y otro fuera. El contexto `Contador = createContext(100)` tiene valor por defecto 100.

`Lejano` no está dentro del Provider: muestra el valor por defecto. `Cercano` sí: muestra el valor del estado. Un botón incrementa el estado; solo `Cercano` cambia.

## Entrada

1. La primera línea: el valor inicial del estado del contador. Si no hay líneas, empieza en 0.
2. Las siguientes son eventos:
   - `clic 1` → incrementa el estado en 1.

## Salida

Una línea por cada render, con las dos etiquetas y el botón, en este orden:

```
<p>fuera: 100</p><p>dentro: 5</p><button>sumar</button>
```

`fuera:` siempre es 100: es el valor por defecto del contexto. `dentro:` es el estado actual.

## Ejemplo

Entrada:
```
5
clic 1
```

Salida:
```
<p>fuera: 100</p><p>dentro: 5</p><button>sumar</button>
<p>fuera: 100</p><p>dentro: 6</p><button>sumar</button>
```
