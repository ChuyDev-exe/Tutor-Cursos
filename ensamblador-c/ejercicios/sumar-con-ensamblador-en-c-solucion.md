```c
#include <stdio.h>

int suma(int a, int b) {
    int r;
    __asm__ volatile("add %w0, %w1, %w2" : "=r"(r) : "r"(a), "r"(b));
    return r;
}

int main(void) {
    int a, b;
    if (scanf("%d %d", &a, &b) != 2) return 0;
    printf("suma=%d\n", suma(a, b));
    return 0;
}
```

`%w0` es la salida `r`, y `%w1` y `%w2` son las entradas `a` y `b`. La instrucción `add destino, origen1, origen2` deja la suma en `r`. El `main` se queda igual: C lee la entrada y el ensamblador solo calcula.
