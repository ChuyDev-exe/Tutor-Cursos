#!/usr/bin/env bash
set -euo pipefail

cat > fuentes.c <<'C'
#include <SDL.h>
#include <SDL_ttf.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) { printf("ERROR SDL: %s\n", SDL_GetError()); return 1; }
    if (TTF_Init() < 0) { printf("ERROR TTF: %s\n", TTF_GetError()); return 1; }

    SDL_Window *ventana = SDL_CreateWindow("Fuentes SDL2", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, 0);
    SDL_Renderer *pincel = SDL_CreateRenderer(ventana, -1, SDL_RENDERER_ACCELERATED);

    // Carga la fuente incluida en la carpeta del ejercicio
    TTF_Font *fuente = TTF_OpenFont("fuente_principal.ttf", 24);
    if (!fuente) { printf("ERROR cargando fuente: %s\n", TTF_GetError()); return 1; }

    // TODO: Completa el código para renderizar "Hola SDL"
    // 1. Superficie: superficie = TTF_RenderText_Solid(fuente, "Hola SDL", (SDL_Color){255, 255, 255});
    // 2. Textura: textura = SDL_CreateTextureFromSurface(pincel, superficie);
    // 3. Dibujar: SDL_RenderCopy(pincel, textura, NULL, &(SDL_Rect){10, 10, 0, 0});
    // 4. Presentar: SDL_RenderPresent(pincel);
    // 5. Liberar: SDL_FreeSurface(superficie); TTF_CloseFont(fuente);

    SDL_Delay(3000);

    TTF_CloseFont(fuente);
    SDL_DestroyRenderer(pincel);
    SDL_DestroyWindow(ventana);
    TTF_Quit();
    SDL_Quit();
    return 0;
}
C

gcc fuentes.c $(sdl2-config --cflags --libs) -lSDL2_ttf -o fuentes
./fuentes