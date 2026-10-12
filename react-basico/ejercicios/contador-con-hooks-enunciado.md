# Contador con hooks

Escribe el componente `Contador` con `useState`: un botón suma y el otro resta.

La plantilla ya incluye el mini React con hooks. Ella lee la entrada y llama a `ejecutar(Contador, { inicial }, eventos)`. Tu trabajo es solo el componente.

## Entrada

Varias líneas:

1. La primera es el valor inicial del contador. Es un número y puede ser negativo.
2. Las siguientes son eventos, uno por línea:
   - `clic 1` pulsa el botón **sumar** (el primer `onClick` del árbol).
   - `clic 2` pulsa el botón **restar** (el segundo `onClick` del árbol).
   - `clic N` con un `N` sin botón no cambia el estado, pero el andamiaje vuelve a renderizar.

Si solo hay una línea, no hay eventos. Una entrada vacía equivale a `0` sin eventos.

El andamiaje también admite `cambiar N texto`; este componente no tiene campos de texto, así que no se usa.

## Salida

Una línea por cada render, con el HTML completo del componente:

`<div><p>0</p><button>sumar</button><button>restar</button></div>`

El contenido del `<p>` es el valor actual del contador. El render inicial se imprime siempre. Después se imprime un render tras cada evento. No imprimas nada más.

## Ejemplo

Entrada:
```
0
clic 1
clic 2
```

Salida:
```
<div><p>0</p><button>sumar</button><button>restar</button></div>
<div><p>1</p><button>sumar</button><button>restar</button></div>
<div><p>0</p><button>sumar</button><button>restar</button></div>
```
