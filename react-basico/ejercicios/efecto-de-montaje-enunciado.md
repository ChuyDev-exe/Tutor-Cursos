# Efecto de montaje

Escribe el componente `Contador` con un efecto que imprime `montado` una sola vez.

La plantilla ya incluye el mini React con hooks y convierte la entrada en la lista de eventos. Tu trabajo es solo el componente.

## Entrada

No hay líneas de datos. Todas las líneas son eventos, uno por línea:

- `clic 1` pulsa el botón **sumar**.

Una entrada vacía significa «ningún evento».

El andamiaje también admite `cambiar N texto`; este componente no tiene campos de texto, así que no se usa.

## Salida

Una línea por cada render con el HTML del componente:

`<div><p>0</p><button>sumar</button></div>`

Después del primer render aparece la línea `montado`. Los renders siguientes no vuelven a imprimirla. No imprimas nada más.

## Ejemplo

Entrada:
```
clic 1
clic 1
```

Salida:
```
<div><p>0</p><button>sumar</button></div>
montado
<div><p>1</p><button>sumar</button></div>
<div><p>2</p><button>sumar</button></div>
```
