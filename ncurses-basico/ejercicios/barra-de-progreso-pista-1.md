Un bucle con `getch()` normal se queda esperando para siempre. La solución es `timeout(1)` al principio: `getch()` espera como mucho 1 ms y devuelve `ERR`.
