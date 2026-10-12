# Estado con objeto

Escribe el componente `Contador` cuyo estado es **un objeto** con dos campos: `n` y `veces`.

La plantilla ya incluye el mini React con hooks y entrega `inicial` y los eventos. Tu trabajo es solo el componente.

## Entrada

Varias líneas:

1. La primera es el valor inicial de `n`. Es un número y puede ser negativo. `veces` empieza en `0`.
2. Las siguientes son eventos, uno por línea:
   - `clic 1` pulsa el botón **sumar**: `n` sube 1 y `veces` sube 1.
   - `clic 2` pulsa el botón **reiniciar**: `n` pasa a `0` y `veces` sube 1.
   - `clic N` con un `N` sin botón no cambia el estado, pero el andamiaje vuelve a renderizar.

El andamiaje también admite `cambiar N texto`; este componente no tiene campos de texto, así que no se usa.

## Salida

Una línea por cada render:

`<div><p>n: 0</p><p>veces: 0</p><button>sumar</button><button>reiniciar</button></div>`

El primer `<p>` muestra `n`. El segundo muestra `veces`. El render inicial se imprime siempre; después, un render tras cada evento. No imprimas nada más.

## Ejemplo

Entrada:
```
10
clic 1
clic 2
```

Salida:
```
<div><p>n: 10</p><p>veces: 0</p><button>sumar</button><button>reiniciar</button></div>
<div><p>n: 11</p><p>veces: 1</p><button>sumar</button><button>reiniciar</button></div>
<div><p>n: 0</p><p>veces: 2</p><button>sumar</button><button>reiniciar</button></div>
```
