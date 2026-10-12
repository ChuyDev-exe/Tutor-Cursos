#include <stdio.h>

int suma(int a, int b) {
    int r = 0;
    // TODO: escribe la instruccion add con las vistas de 32 bits (%w0, %w1, %w2)
    __asm__ volatile("" : "=r"(r) : "r"(a), "r"(b));
    return r;
}

int main(void) {
    int a, b;
    if (scanf("%d %d", &a, &b) != 2) return 0;
    printf("suma=%d\n", suma(a, b));
    return 0;
}
