# 6. useEffect: montaje, dependencias y limpieza

## Objetivo

Al terminar este capítulo sabrás cuándo corre un efecto, cómo elegir sus dependencias y para qué sirve la función de limpieza.

## Qué es un efecto

Un **efecto** es código que sale del render: suscribirse a algo, medir, sincronizar con el exterior. Se escribe con el hook `useEffect`:

```js
useEffect(() => {
  console.log("montado");
}, []);
```

El primer argumento es la función del efecto. El segundo es la lista de dependencias.

## Cuándo se ejecuta

El efecto corre después del render, solo si algo de la lista de dependencias cambió.

En el andamiaje el orden se ve claramente: primero se imprime el HTML del render; después corren los efectos y sus `console.log`.

```
<div><p>0</p></div>
valor: 0
```

## Las tres formas de dependencias

- `[]`: solo al montar, la primera vez.
- `[a, b]`: al montar y cada vez que `a` o `b` cambian.
- Sin lista: en cada render.

La comparación usa `Object.is`. Dos números, textos o booleanos son iguales si tienen el mismo valor.

## Función de limpieza

Si el efecto devuelve una función, esa es la **limpieza**. Corre antes de volver a ejecutar el efecto.

```js
useEffect(() => {
  console.log("conectado");
  return () => console.log("desconectado");
}, [conectado]);
```

La limpieza deshace lo anterior: quita un temporizador o cancela una suscripción.

## Qué no va en un efecto

- Calcular un valor derivado: eso va en el render.
- Repetir el flujo del render: render, efecto, setState, render.

Un efecto es para sincronizar React con algo fuera de React.

## Reglas de los hooks

Los efectos son hooks. Aplican las reglas del capítulo anterior:

1. Mismo orden en cada render.
2. Nunca dentro de un `if` ni de un bucle.

Elige las dependencias con cuidado. Si sobran, hay renders de más. Si faltan, el efecto no se actualiza.

## Gramática de eventos del andamiaje

Repaso de las líneas que acepta `parsearEventos`:

- `clic` o `clic N`: llama al N-ésimo `onClick` del árbol.
- `cambiar N texto`: llama al N-ésimo `onChange` con el texto escrito.
- Cualquier otra línea es un error. Por eso la entrada consume antes las líneas de datos.

`ejecutar` imprime una línea por render. Después imprime los mensajes de los efectos de ese render.

## Qué vas a practicar

- Montar un efecto con `[]` que corre una sola vez.
- Elegir las dependencias de un efecto con `[n]`.
- Escribir una limpieza que se imprime antes del siguiente efecto.
