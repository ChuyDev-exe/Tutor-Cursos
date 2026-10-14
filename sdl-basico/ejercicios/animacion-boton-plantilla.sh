#!/usr/bin/env bash
set -euo pipefail

cat > animacion.c <<'C'
#include <SDL.h>
#include <stdio.h>

#define ANCHO 800
#define ALTO 600
#define R 20
#define VEL 200

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) { printf("ERROR SDL: %s\n", SDL_GetError()); return 1; }

    SDL_Window *ventana = SDL_CreateWindow("Animación SDL2", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, ANCHO, ALTO, 0);
    SDL_Renderer *pincel = SDL_CreateRenderer(ventana, -1, SDL_RENDERER_ACCELERATED);

    // Pelota: centro (x, y) y velocidad (velx, vely)
    float x = ANCHO / 2.0;
    float y = ALTO / 2.0;
    int velx = 1;
    int vely = 1;

    SDL_Event e;
    int corriendo = 1;

    while (corriendo) {
        // Leer eventos
        while (SDL_PollEvent(&e) != 0) {
            if (e.type == SDL_QUIT) corriendo = 0;
        }

        // TODO: Completa actualizar_animacion
        // 1. ticks = SDL_GetTicks();
        // 2. dt = ticks / 1000.0;
        // 3. x += velx * dt;
        // 4. y += vely * dt;
        // 5. if (x - R < 0) { velx = -velx; x = R; }
        //    if (x + R > ANCHO) { velx = -velx; x = ANCHO - R; }
        //    if (y - R < 0) { vely = -vely; y = R; }
        //    if (y + R > ALTO) { vely = -vely; y = ALTO - R; }

        // Borrar pantalla (fondo blanco)
        SDL_SetRenderDrawColor(pincel, 255, 255, 255, 255);
        SDL_RenderClear(pincel);

        // Dibujar pelota (rectángulo que simula un círculo)
        SDL_Rect bola = {(int)(x - R), (int)(y - R), R * 2, R * 2};
        SDL_SetRenderDrawColor(pincel, 0, 0, 255, 255);
        SDL_RenderFillRect(pincel, &bola);

        SDL_RenderPresent(pincel);
    }

    SDL_DestroyRenderer(pincel);
    SDL_DestroyWindow(ventana);
    SDL_Quit();
    return 0;
}
C

gcc animacion.c $(sdl2-config --cflags --libs) -o animacion
./animacion