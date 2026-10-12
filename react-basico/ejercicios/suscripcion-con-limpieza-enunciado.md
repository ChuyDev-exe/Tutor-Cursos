# Suscripcion con limpieza

Escribe el componente `Conexion` con un efecto que conecta, desconecta y limpia tras sí.

La plantilla ya incluye el mini React con hooks y convierte la entrada en la lista de eventos. Tu trabajo es solo el componente.

## Entrada

No hay líneas de datos. Todas las líneas son eventos, uno por línea:

- `clic 1` pulsa el botón **alternar** y cambia `conectado`.

`conectado` empieza en `false`. Una entrada vacía significa «ningún evento».

El andamiaje también admite `cambiar N texto`; este componente no tiene campos de texto, así que no se usa.

## Salida

Una línea por cada render con el HTML del componente:

`<div><p>no</p><button>alternar</button></div>`

El `<p>` muestra `si` o `no` según `conectado`. Después del HTML de cada render salen los mensajes del efecto:

- Si `conectado` es `true`, el efecto imprime `conectado` y devuelve una limpieza que imprime `desconectado`.
- Si `conectado` es `false`, el efecto imprime `desconectado` y no devuelve nada.
- La limpieza corre siempre antes del siguiente efecto, ya después del HTML del render.

No imprimas nada más.

## Ejemplo

Entrada:
```
clic 1
clic 1
```

Salida:
```
<div><p>no</p><button>alternar</button></div>
desconectado
<div><p>si</p><button>alternar</button></div>
conectado
<div><p>no</p><button>alternar</button></div>
desconectado
desconectado
```
