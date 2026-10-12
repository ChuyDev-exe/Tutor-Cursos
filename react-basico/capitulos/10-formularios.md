# 10. Formularios controlados

## Objetivo

Al terminar este capítulo sabrás escribir formularios controlados: el estado manda y cada tecla pasa por React.

## Un input controlado

Un **input controlado** es un input cuyo valor sale del estado. La prop `value` muestra ese estado y `onChange` lo actualiza.

```js
function Nombre() {
  const [texto, setTexto] = useState("");
  return h("input", {
    value: texto,
    onChange: (e) => setTexto(e.target.value),
  });
}
```

Cada pulsación dispara `onChange`. React guarda el texto y vuelve a pintar el input. El estado es la única fuente de verdad.

## Por qué no tocar el DOM directamente

En React el render decide lo que se pinta. Si escribes en el DOM a mano, el siguiente render lo sobrescribe.

```js
// No: el cambio desaparece en el siguiente render
document.getElementById("nombre").value = "Ana";
```

Con `value` en el estado, el DOM siempre refleja lo que React calculó.

## Varios campos en un objeto

Cuando hay varios campos, el estado suele ser un objeto. Cada `onChange` copia el objeto y cambia un campo:

```js
const [datos, setDatos] = useState({ nombre: "", correo: "" });
// en el onChange del correo:
setDatos((d) => ({ ...d, correo: e.target.value }));
```

El spread copia las propiedades y el campo nuevo pisa el anterior. Los demás campos quedan igual.

## Validar al enviar

La **validación** comprueba reglas: campos obligatorios, formatos, longitudes. Lo habitual es validar al pulsar el botón de enviar.

```js
const enviar = () => {
  if (datos.nombre === "") setError("nombre requerido");
};
```

Guardar el error en el estado permite pintarlo después.

## Mostrar los errores

Los errores se muestran con renderizado condicional. El operador `&&` pinta solo si hay mensaje:

```js
error && h("p", {}, error);
```

Un ternario también sirve: `error ? h("p", {}, error) : null`. Sin error no hay elemento y no se pinta nada.

## Enviar y limpiar

Si la validación pasa, se muestra un mensaje de éxito y los errores quedan vacíos. Si falla, se muestran los mensajes.

Para **limpiar el formulario** vuelves a los valores iniciales con un objeto nuevo:

```js
setDatos({ nombre: "", correo: "" });
```

No borras campo a campo sobre el mismo objeto: creas uno nuevo.

## Eventos del andamiaje en formularios

Los ejercicios de este capítulo usan el andamiaje del curso:

- `cambiar N texto` simula escribir en el N-ésimo `onChange`, con `{ target: { value: texto } }`.
- `clic N` pulsa el N-ésimo `onClick` en orden del árbol.
- `ejecutar(Componente, props, eventos)` imprime una línea por cada render.

Los dos tipos de evento se cuentan por separado: `clic N` solo mira `onClick` y `cambiar N texto` solo mira `onChange`.

## Qué vas a practicar

- Controlar un input con `value` y `onChange`.
- Actualizar varios campos con un objeto y spread.
- Validar al enviar y pintar errores con `&&` o un ternario.
- Limpiar el formulario con un objeto nuevo.
