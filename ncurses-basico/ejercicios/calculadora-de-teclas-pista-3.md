Actualiza el display al final de cada vuelta del bucle, según la fase:

```c
if (fase == 0) snprintf(display, DISPLAY_TAM, "%ld", izq);
else if (fase == 1) snprintf(display, DISPLAY_TAM, "%ld %c", izq, op);
else snprintf(display, DISPLAY_TAM, "%ld %c %ld", izq, op, der);
```

Con `snprintf` el búfer de 32 bytes nunca se desborda.
