La forma de la función es esta, sin la parte clave:

```js
function Formulario() {
  const [datos, setDatos] = useState({ nombre: "", correo: "" });
  // TODO: estado de errores y bandera de envío
  const enviar = () => {
    const errs = { nombre: "", correo: "" };
    if (datos.nombre === "") /* aquí */;
    if (!datos.correo.includes("@")) /* aquí */;
    // TODO: guarda errs en el estado y activa la bandera si no hay errores
  };
  // TODO: dos inputs controlados, los errores como <p> y el mensaje de éxito
}
```
