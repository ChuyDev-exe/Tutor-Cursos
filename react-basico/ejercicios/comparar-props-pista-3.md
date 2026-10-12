La forma de la función es esta, sin la línea clave:

```js
function iguales(a, b) {
  const clavesA = Object.keys(a);
  const clavesB = Object.keys(b);
  if (/* aquí */) return "no";
  for (const clave of clavesA) {
    /* aquí */
  }
  return "si";
}
```
