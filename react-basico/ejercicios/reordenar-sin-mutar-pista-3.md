La forma de la función es esta, sin las líneas clave:

```js
function aplicar(lista, acciones) {
  let actual = lista;
  for (const accion of acciones) {
    if (accion.tipo === "añadir") { /* aquí */ }
    if (accion.tipo === "quitar") { /* aquí */ }
    if (accion.tipo === "subir") { /* aquí */ }
    if (accion.tipo === "bajar") { /* aquí */ }
  }
  return actual;
}
```
