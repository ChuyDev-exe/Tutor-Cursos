`scanf` necesita la dirección de la variable donde va a guardar el entero. En macOS con chip Apple esa dirección va en la pila, en `[sp+0]`, y no en el registro `x1`.
