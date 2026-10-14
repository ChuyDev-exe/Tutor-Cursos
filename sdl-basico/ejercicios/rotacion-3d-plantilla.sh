#!/usr/bin/env bash
set -euo pipefail

cat > rotacion3d.c <<'C'
#include <SDL.h>
#include <stdio.h>
#include <math.h>

#define ANCHO 800
#define ALTO 600
#define D 1

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) { printf("ERROR SDL: %s\n", SDL_GetError()); return 1; }

    SDL_Window *ventana = SDL_CreateWindow("3D Rotating Triangle", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, ANCHO, ALTO, 0);
    SDL_Renderer *pincel = SDL_CreateRenderer(ventana, -1, SDL_RENDERER_SOFTWARE);

    SDL_Event e;
    int corriendo = 1;

    while (corriendo) {
        while (SDL_PollEvent(&e) != 0) {
            if (e.type == SDL_QUIT) corriendo = 0;
        }

        // TODO: Completa proyectar_y_dibujar
        // 1. ticks = SDL_GetTicks();
        // 2. angle = (ticks / 1000.0) * 0.5;
        // 3. Vértice A original: (0, 100, 5)
        //    xA_rot = 0 * cos(angle) - 200 * sin(angle);
        //    zA_rot = 0 * sin(angle) + 200 * cos(angle);
        //    yA = 100;
        //    inv_zA = 1.0 / (zA_rot + D);
        //    pxA = xA_rot * inv_zA * 10;
        //    pyA = yA * inv_zA * 10;
        // 4. Vértice B original: (-80, -80, 5)
        //    xB_rot = -80 * cos(angle) - 200 * sin(angle);
        //    zB_rot = -80 * sin(angle) + 200 * cos(angle);
        //    yB = -80;
        //    inv_zB = 1.0 / (zB_rot + D);
        //    pxB = xB_rot * inv_zB * 10;
        //    pyB = yB * inv_zB * 10;
        // 5. Vértice C original: (80, -80, 5)
        //    xC_rot = 80 * cos(angle) - 200 * sin(angle);
        //    zC_rot = 80 * sin(angle) + 200 * cos(angle);
        //    yC = -80;
        //    inv_zC = 1.0 / (zC_rot + D);
        //    pxC = xC_rot * inv_zC * 10;
        //    pyC = yC * inv_zC * 10;
        // 6. Dibujar líneas:
        //    SDL_RenderDrawLine(pincel, pxA, pyA, pxB, pyB);
        //    SDL_RenderDrawLine(pincel, pxB, pyB, pxC, pyC);
        //    SDL_RenderDrawLine(pincel, pxC, pyC, pxA, pyA);

        // Fondo negro
        SDL_SetRenderDrawColor(pincel, 10, 10, 10, 255);
        SDL_RenderClear(pincel);

        SDL_RenderPresent(pincel);
    }

    SDL_DestroyRenderer(pincel);
    SDL_DestroyWindow(ventana);
    SDL_Quit();
    return 0;
}
C

gcc rotacion3d.c $(sdl2-config --cflags --libs) -o rotacion3d -lm
./rotacion3d