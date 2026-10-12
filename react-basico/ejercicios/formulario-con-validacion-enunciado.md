# Formulario con validacion

Escribe el componente `Formulario`, un formulario controlado con dos campos: nombre y correo. Al enviar, valida los dos y muestra los errores o el mensaje de éxito.

Cada campo vive en el estado y se actualiza con spread, así que escribir en uno no toca al otro.

## Entrada

Solo eventos:

- `cambiar 1 texto` escribe en el input de nombre.
- `cambiar 2 texto` escribe en el input de correo.
- `clic 1` pulsa el botón «enviar».

## Salida

Una línea por cada render: el inicial y uno tras cada evento.

La validación ocurre solo al enviar:

- nombre vacío → `nombre requerido`
- correo sin `@` → `correo invalido`

Cada error se pinta como `<p>` debajo de su input, solo si existe. Si los dos campos son válidos, se pinta `enviado: <nombre>` y los errores desaparecen. Escribir tras un envío exitoso apaga el mensaje de éxito. Los errores solo se recalculan al enviar.

## Ejemplo

Entrada:
```
cambiar 1 ana
cambiar 2 ana@x.com
clic 1
```

Salida:
```
<div><input value=""></input><input value=""></input><button>enviar</button></div>
<div><input value="ana"></input><input value=""></input><button>enviar</button></div>
<div><input value="ana"></input><input value="ana@x.com"></input><button>enviar</button></div>
<div><input value="ana"></input><input value="ana@x.com"></input><button>enviar</button><p>enviado: ana</p></div>
```
