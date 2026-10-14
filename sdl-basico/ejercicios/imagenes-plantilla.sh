#!/usr/bin/env bash
set -euo pipefail

cat > imagenes.c <<'C'
#include <SDL.h>
#include <SDL_image.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) { printf("ERROR SDL: %s\n", SDL_GetError()); return 1; }
    int flags = IMG_INIT_PNG;
    if ((IMG_Init(flags) & flags) != flags) { printf("ERROR IMG: %s\n", IMG_GetError()); return 1; }

    SDL_Window *ventana = SDL_CreateWindow("Imágenes SDL2", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, 0);
    SDL_Renderer *pincel = SDL_CreateRenderer(ventana, -1, SDL_RENDERER_ACCELERATED);

    // TODO: Completa el código para mostrar la imagen
    // 1. Superficie: superficie = IMG_Load("imagen_jugador.png");
    // 2. Textura: textura = SDL_CreateTextureFromSurface(pincel, superficie);
    // 3. Dimensiones: w = superficie->w; h = superficie->h;
    // 4. Rectángulo centrado: rect = {(800 - w) / 2, (600 - h) / 2, w, h};
    // 5. Dibujar: SDL_RenderCopy(pincel, textura, NULL, &rect);
    // 6. Presentar: SDL_RenderPresent(pincel);
    // 7. Retraso: SDL_Delay(3000);
    // 8. Liberar: SDL_FreeSurface(superficie); SDL_DestroyTexture(textura);

    IMG_Quit();
    SDL_DestroyRenderer(pincel);
    SDL_DestroyWindow(ventana);
    SDL_Quit();
    return 0;
}
C

gcc imagenes.c $(sdl2-config --cflags --libs) -lSDL2_image -o imagenes
./imagenes