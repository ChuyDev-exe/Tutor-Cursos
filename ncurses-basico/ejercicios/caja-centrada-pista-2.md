Para el ancho usa `strlen` y un `if`:

```c
int ancho = (int)strlen(titulo);
if ((int)strlen(mensaje) > ancho) ancho = (int)strlen(mensaje);
ancho += 6;
if (ancho < 10) ancho = 10;
```
