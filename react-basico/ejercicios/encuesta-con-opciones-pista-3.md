La forma de la función es esta, sin la parte clave:

```js
function Encuesta({ opciones }) {
  const [seleccion, setSeleccion] = useState("");
  const [enviada, setEnviada] = useState(false);
  // TODO: elegir(op) guarda op y apaga la bandera
  // TODO: enviar() solo activa la bandera si seleccion !== ""
  // TODO: mensaje = "resultado: ..." o "elige una opcion", con un if
  return h("div", {},
    ...opciones.map((op) => h("button", { className: /* aquí */, onClick: /* aquí */ }, op)),
    h("button", { onClick: /* aquí */ }, "enviar"),
    /* aquí */
  );
}
```
