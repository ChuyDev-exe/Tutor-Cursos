# Encuesta con opciones

Escribe el componente `Encuesta`, una encuesta con tres opciones fijas: rojo, verde y azul. Cada opción es un botón; un cuarto botón envía la respuesta.

La selección y el envío son dos estados. Elegir una opción la marca con `className="opcion activa"`; las demás quedan con `className="opcion"`.

## Entrada

Solo eventos:

- `clic 1`, `clic 2` y `clic 3` eligen rojo, verde y azul.
- `clic 4` pulsa el botón «enviar».

## Salida

Una línea por cada render: el inicial y uno tras cada evento.

- Sin selección se pinta `elige una opcion`.
- Enviar con selección activa la bandera y se pinta `resultado: <opción>`.
- Elegir otra opción apaga la bandera: el resultado deja de mostrarse.
- Enviar sin selección no cambia nada; el mensaje `elige una opcion` ya estaba pintado.

## Ejemplo

Entrada:
```
clic 2
clic 4
```

Salida:
```
<div><button className="opcion">rojo</button><button className="opcion">verde</button><button className="opcion">azul</button><button>enviar</button><p>elige una opcion</p></div>
<div><button className="opcion">rojo</button><button className="opcion activa">verde</button><button className="opcion">azul</button><button>enviar</button></div>
<div><button className="opcion">rojo</button><button className="opcion activa">verde</button><button className="opcion">azul</button><button>enviar</button><p>resultado: verde</p></div>
```
