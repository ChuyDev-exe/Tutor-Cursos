# Resumen de tareas

Escribe el componente `Resumen`: pinta las tareas, un resumen derivado y un botón que alterna el filtro.

La plantilla ya incluye el mini React con hooks y convierte la entrada en el prop `tareas` (un array de `{ texto, hecha }`). Tu trabajo es solo el componente.

## Entrada

Varias líneas:

1. La primera es el número de tareas.
2. Después, una línea por tarea con el formato `texto:hecha`, donde `hecha` es `si` o `no`. El `texto` no contiene dos puntos.
3. Después vienen los eventos, uno por línea:
   - `clic 1` pulsa el botón **mostrar todas**. Con `true` se ven todas las tareas; con `false` solo las pendientes.

El andamiaje también admite `cambiar N texto`; este componente no tiene campos de texto, así que no se usa.

Si el número es `0`, no hay líneas de tarea.

## Salida

Una línea por cada render. Estructura del HTML:

`<div><button>mostrar todas</button><p>Hechas: 1 de 3</p><ul><li key="comprar" className="tarea hecha">comprar</li></ul></div>`

- El `<p>` es el resumen derivado: `Hechas: X de Y`, con `X` las hechas y `Y` el total. Se calcula en cada render.
- Cada `<li>` lleva `key` con el texto y `className` `tarea hecha` o `tarea pendiente`.
- Con el filtro activo solo aparecen las tareas pendientes en el `<ul>`.

No imprimas nada más.

## Ejemplo

Entrada:
```
3
comprar:si
limpiar:no
nadar:no
clic 1
```

Salida:
```
<div><button>mostrar todas</button><p>Hechas: 1 de 3</p><ul><li key="comprar" className="tarea hecha">comprar</li><li key="limpiar" className="tarea pendiente">limpiar</li><li key="nadar" className="tarea pendiente">nadar</li></ul></div>
<div><button>mostrar todas</button><p>Hechas: 1 de 3</p><ul><li key="limpiar" className="tarea pendiente">limpiar</li><li key="nadar" className="tarea pendiente">nadar</li></ul></div>
```
