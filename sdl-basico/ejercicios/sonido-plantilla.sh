#!/usr/bin/env bash
set -euo pipefail

cat > sonido.c <<'C'
#include <SDL.h>
#include <SDL_mixer.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) { printf("ERROR SDL: %s\n", SDL_GetError()); return 1; }

    if (Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0) {
        printf("ERROR mixer: %s\n", Mix_GetError());
        return 1;
    }

    SDL_Window *ventana = SDL_CreateWindow("Sonido SDL2", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, 0);
    SDL_Renderer *pincel = SDL_CreateRenderer(ventana, -1, SDL_RENDERER_ACCELERATED);

    // TODO: Completa el código
    // 1. Cargar sonido: golpe = Mix_LoadWAV("golpe.wav");
    // 2. Si golpe, ajustar volumen: Mix_VolumeChunk(golpe, 64);
    // 3. Bucle de eventos
    //    while (SDL_PollEvent(&e) != 0) {
    //        if (e.type == SDL_QUIT) corriendo = 0;
    //        if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_SPACE) {
    //            Mix_PlayChannel(-1, golpe, 0);
    //        }
    //    }
    // 4. Retraso y limpieza
    //    SDL_Delay(3000);
    //    Mix_FreeChunk(golpe);
    //    SDL_DestroyRenderer(pincel);
    //    SDL_DestroyWindow(ventana);
    //    Mix_CloseAudio();
    //    SDL_Quit();

    return 0;
}
C

gcc sonido.c $(sdl2-config --cflags --libs) -lSDL2_mixer -o sonido
./sonido