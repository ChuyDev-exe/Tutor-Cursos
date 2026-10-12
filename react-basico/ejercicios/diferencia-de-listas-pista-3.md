La forma de la función es esta, sin la línea clave de cada array:

```js
function diferencia(anterior, siguiente) {
  const añadidos = /* claves de siguiente que no están en anterior */;
  const quitados = /* claves de anterior que no están en siguiente */;
  const movidos = /* claves de ambos cuya posición no coincide */;
  return { añadidos, quitados, movidos };
}
```
