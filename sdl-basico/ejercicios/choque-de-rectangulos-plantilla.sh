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

    // TODO 1: comprueba con SDL_HasIntersection si a y b se solapan
    // TODO 2: si se solapan, calcula el rectángulo común con SDL_IntersectRect
    //         e imprime "choque" y, en otra línea, "interseccion: x y w h"
    // TODO 3: si no se solapan, imprime "libre"
    return 0;
}
C

gcc choque.c $(sdl2-config --cflags --libs) -o choque
./choque
