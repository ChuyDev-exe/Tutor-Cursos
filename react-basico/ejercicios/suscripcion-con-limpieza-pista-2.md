El efecto depende de `[conectado]`, así que corre cada vez que el booleano cambia. Con `return () => console.log("desconectado")` solo en la rama `true` queda registrada la limpieza.
