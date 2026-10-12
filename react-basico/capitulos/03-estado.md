# 3. Estado: useState y useReducer

## Objetivo

Al terminar este capítulo sabrás qué es el estado, por qué no se modifica directamente y cómo un reducer calcula el siguiente valor.

## El estado cambia con el tiempo

Muchas interfaces recuerdan datos: un contador, un texto escrito, si un menú está abierto. Eso es el **estado**: datos que cambian durante la vida del componente.

La primera regla de React sobre el estado es corta: **no lo modifiques**. En vez de cambiar el valor que ya tienes, calculas uno nuevo y lo guardas.

```js
// No
estado.contador = estado.contador + 1;

// Sí
const nuevo = { ...estado, contador: estado.contador + 1 };
```

El `{ ...estado }` copia las propiedades en un objeto nuevo. React compara el objeto anterior con el nuevo. Si son distintos, redibuja la interfaz. Si mutas el mismo objeto, la referencia no cambia y React no ve nada.

## Un estado puede ser un objeto

El estado no tiene que ser un número. Un objeto con varios campos es común:

```js
const estado = { contador: 0, visible: true };
```

Para actualizarlo siempre devuelves un objeto nuevo con la copia superficial más el campo que cambia:

```js
{ ...estado, visible: !estado.visible }
```

## Acciones: describir el cambio

En lugar de escribir la lógica de cambio en muchos sitios, se describe **qué pasó** como una acción:

```js
{ tipo: "incrementar" }
{ tipo: "fijar", valor: 10 }
{ tipo: "alternar" }
```

Una acción es un objeto con un `tipo` y los datos que hagan falta. Quien interactúa con la interfaz «despacha» una acción; la lógica de cambio decide el resultado.

## Un reducer es una función pura

El **reducer** recibe el estado actual y una acción, y devuelve el siguiente estado:

```js
function reducer(estado, accion) {
  if (accion.tipo === "incrementar") return estado + 1;
  if (accion.tipo === "fijar") return accion.valor;
  return estado;
}
```

Tres propiedades importantes:

1. **No muta**: siempre devuelve un valor nuevo o el mismo.
2. **No depende del exterior**: con las mismas entradas, da la misma salida.
3. **Devuelve el estado si la acción no aplica**: nada cambia.

En React esta función se conecta con el hook `useReducer`, que entrega el estado y una función para despachar acciones.

## Aplicar varias acciones

Varias acciones en orden forman una secuencia. Se aplica el reducer de izquierda a derecha:

```js
let estado = 0;
for (const accion of acciones) {
  estado = reducer(estado, accion);
}
```

Es el mismo bucle que haría React por ti tras cada acción.

## Qué vas a practicar

- Escribir un reducer para un contador.
- Actualizar un objeto de estado con dos campos sin mutarlo.
- Parsear acciones desde la entrada y aplicarlas en orden.
