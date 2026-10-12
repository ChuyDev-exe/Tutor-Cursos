Para pasar la dirección del string a `printf`: primero carga la página con `adrp x0, etiqueta@PAGE` y después la parte final con `add x0, x0, etiqueta@PAGEOFF`. La llamada se hace con `bl _printf`.
