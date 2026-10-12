# Hook useContador

Escribe el hook `useContador(inicial)`, que guarda un número en el estado y devuelve su valor junto con tres manejadores.

La plantilla ya trae el componente `Contador`, que usa el hook y pinta un párrafo con el número y dos botones: sumar y restar. No modifiques el componente; solo escribe el hook.

## Entrada

Dos partes, en este orden:

1. La primera línea es el valor inicial del contador.
2. El resto son eventos:
   - `clic 1` pulsa el botón «sumar».
   - `clic 2` pulsa el botón «restar».

## Salida

Una línea por cada render. El andamiaje imprime el render inicial y después un render tras cada evento, aunque el estado no cambie.

No hay límite: `restar` puede bajar por debajo de cero.

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
