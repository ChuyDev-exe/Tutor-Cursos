La conversión y el rango pueden quedar así:

```c
if (digitos_ok) *edad = (int)strtol(edad_txt, NULL, 10);
*valido = (correo_ok && *edad > 0 && *edad < 150) ? 1 : 0;
```
