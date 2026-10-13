```bash
#!/usr/bin/env bash
set -euo pipefail

cat > choque.c <<'C'
#include <SDL.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    SDL_Rect a, b;
    if (scanf("%d %d %d %d", &a.x, &a.y, &a.w, &a.h) != 4) return 0;
    if (scanf("%d %d %d %d", &b.x, &b.y, &b.w, &b.h) != 4) return 0;

    if (SDL_HasIntersection(&a, &b)) {
        SDL_Rect comun;
        SDL_IntersectRect(&a, &b, &comun);
        printf("choque\n");
        printf("interseccion: %d %d %d %d\n", comun.x, comun.y, comun.w, comun.h);
    } else {
        printf("libre\n");
    }
    return 0;
}
C

gcc choque.c $(sdl2-config --cflags --libs) -o choque
./choque
```

`SDL_HasIntersection` responde si dos rectángulos comparten al menos un píxel. `SDL_IntersectRect` además escribe el rectángulo común en el tercer argumento. Dos rectángulos que solo se tocan por el borde no se solapan: el píxel `x + w` ya no forma parte del rectángulo.
