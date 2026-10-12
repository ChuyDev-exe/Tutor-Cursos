# Efecto con dependencias

Escribe el componente `Contador` con dos efectos: uno que corre solo al montar y otro que sigue al contador.

La plantilla ya incluye el mini React con hooks y convierte la entrada en la lista de eventos. Tu trabajo es solo el componente.

## Entrada

No hay líneas de datos. Todas las líneas son eventos, uno por línea:

- `clic 1` pulsa el botón **sumar**.

Una entrada vacía significa «ningún evento».

El andamiaje también admite `cambiar N texto`; este componente no tiene campos de texto, así que no se usa.

## Salida

Una línea por cada render con el HTML del componente:

`<div><p>0</p><button>sumar</button></div>`

Después del HTML de cada render salen los mensajes de sus efectos, en el orden en que se ejecutan:

- `montado` aparece una sola vez, tras el primer render.
- `valor: <n>` aparece tras cada render en que `n` cambió, empezando por `valor: 0`.

No imprimas nada más.

## Ejemplo

Entrada:
```
clic 1
```

Salida:
```
<div><p>0</p><button>sumar</button></div>
montado
valor: 0
<div><p>1</p><button>sumar</button></div>
valor: 1
```
