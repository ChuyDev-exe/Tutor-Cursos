#!/usr/bin/env bash
set -euo pipefail

cat > teclado.c <<'C'
#include <SDL.h>
#include <stdio.h>

#define ANCHO 800
#define ALTO 600

int x = 400;
int y = 500;
#define W 50
#define H 30

void manejar_tecla(SDL_Keycode tecla) {
    // TODO: Completa esta función
    // if (tecla == SDLK_LEFT)  x -= 5;
    // if (tecla == SDLK_RIGHT) x += 5;
    // if (tecla == SDLK_UP)    y -= 5;
    // if (tecla == SDLK_DOWN)  y += 5;
    // if (x < 0)             x = 0;
    // if (x + W > ANCHO)     x = ANCHO - W;
    // if (y < 0)             y = 0;
    // if (y + H > ALTO)      y = ALTO - H;
}

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) { printf("ERROR SDL: %s\n", SDL_GetError()); return 1; }

    SDL_Window *ventana = SDL_CreateWindow("Teclado + callback", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, ANCHO, ALTO, 0);
    SDL_Renderer *pincel = SDL_CreateRenderer(ventana, -1, SDL_RENDERER_ACCELERATED);

    SDL_Event e;
    int corriendo = 1;

    while (corriendo) {
        while (SDL_PollEvent(&e) != 0) {
            if (e.type == SDL_QUIT) corriendo = 0;
            else if (e.type == SDL_KEYDOWN) {
                manejar_tecla(e.key.keysym.sym);
            }
        }

        // Borrar pantalla
        SDL_SetRenderDrawColor(pincel, 30, 30, 30, 255);
        SDL_RenderClear(pincel);

        // Dibujar rectángulo
        SDL_Rect r = {x, y, W, H};
        SDL_SetRenderDrawColor(pincel, 255, 100, 100, 255);
        SDL_RenderFillRect(pincel, &r);

        SDL_RenderPresent(pincel);
    }

    SDL_DestroyRenderer(pincel);
    SDL_DestroyWindow(ventana);
    SDL_Quit();
    return 0;
}
C

gcc teclado.c $(sdl2-config --cflags --libs) -o teclado
./teclado