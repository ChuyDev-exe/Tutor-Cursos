#!/usr/bin/env bash
set -euo pipefail

cat > juego-mini.c <<'C'
#include <SDL.h>
#include <SDL_ttf.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ANCHO 800
#define ALTO 600
#define FPS 60
#define FRAME_DELAY (1000 / FPS)

#define VELOCIDAD_JUGADOR 5
#define TIEMPO_JUEGO 30000

typedef struct {
    int x, y, w, h;
    int velx, vely;
    int puntuacion;
    int ticks_inicio;
} Juego;

void inicializar_juego(Juego *j) {
    // TODO: Inicializa los datos del juego
    // j->j->x = 400; j->y = 500; j->w = 50; j->h = 30;
    // j->puntuacion = 0;
    // j->ticks_inicio = SDL_GetTicks();
    // Colocar el cuadrado rojo en posición aleatoria en la parte superior
    // j->rojo_x = rand() % (ANCHO - 30);
    // j->rojo_y = 0 + rand() % (ALTO / 4);
    // j->rojo_w = 30; j->rojo_h = 30;
    // j->rojo_velx = (rand() % 3) + 1;
    // j->rojo_vely = (rand() % 3) + 1;
    // Si la velocidad es par, positiva; si es impar, negativa
    // if (j->rojo_velx % 2 == 0) j->rojo_velx = -j->rojo_velx;
    // if (j->rojo_vely % 2 == 0) j->rojo_vely = -j->rojo_vely;
}

void procesar_eventos(Juego *j) {
    // TODO: Vacía la cola de eventos
    // if (e.type == SDL_QUIT) corriendo = 0;
    // if (e.type == SDL_KEYDOWN) {
    //     switch (e.key.keysym.sym) {
    //         case SDLK_LEFT:  j->x -= VELOCIDAD_JUGADOR; break;
    //         case SDLK_RIGHT: j->x += VELOCIDAD_JUGADOR; break;
    //         case SDLK_UP:    j->y -= VELOCIDAD_JUGADOR; break;
    //         case SDLK_DOWN:  j->y += VELOCIDAD_JUGADOR; break;
    //     }
    // }
    // Mantener al jugador dentro de la ventana
    // if (j->x < 0) j->x = 0;
    // if (j->x + j->w > ANCHO) j->x = ANCHO - j->w;
    // if (j->y < 0) j->y = 0;
    // if (j->y + j->h > ALTO) j->y = ALTO - j->h;
}

void actualizar_juego(Juego *j) {
    // TODO: Actualiza la posición del cuadrado rojo
    // j->rojo_x += j->rojo_velx;
    // j->rojo_y += j->rojo_vely;
    // if (j->rojo_x < 0) j->rojo_x = 0;
    // if (j->rojo_x + j->rojo_w > ANCHO) j->rojo_x = ANCHO - j->rojo_w;
    // if (j->rojo_y < 0) j->rojo_y = 0;
    // if (j->rojo_y + j->rojo_h > ALTO) j->rojo_y = ALTO - j->rojo_h;
    // // Verificar choque con el jugador
    // SDL_Rect jugador = {j->x, j->y, j->w, j->h};
    // SDL_Rect rojo = {j->rojo_x, j->rojo_y, j->rojo_w, j->rojo_h};
    // if (SDL_HasIntersection(&jugador, &rojo)) {
    //     j->puntuacion += 10;
    //     // Reubicar rojo en posición aleatoria arriba
    //     j->rojo_x = rand() % (ANCHO - 30);
    //     j->rojo_y = 0 + rand() % (ALTO / 4);
    //     // Nueva velocidad aleatoria
    //     j->rojo_velx = (rand() % 3) + 1;
    //     j->rojo_vely = (rand() % 3) + 1;
    //     if (j->rojo_velx % 2 == 0) j->rojo_velx = -j->rojo_velx;
    //     if (j->rojo_vely % 2 == 0) j->rojo_vely = -j->rojo_vely;
    // }
    // // Tiempo restante
    // int ticks_actuales = SDL_GetTicks();
    // int tiempo_restante = TIEMPO_JUEGO - (ticks_actuales - j->ticks_inicio);
    // if (tiempo_restante <= 0) {
    //     printf("Juego terminado: Puntuacion %d\n", j->puntuacion);
    // }
}

void dibujar_juego(Juego *j, TTF_Font *fuente) {
    // TODO: Borra pantalla con color oscuro
    // SDL_SetRenderDrawColor(pincel, 20, 20, 30, 255);
    // SDL_RenderClear(pincel);
    // // Dibuja al jugador (cuadrado blanco)
    // SDL_Rect jugador = {j->x, j->y, j->w, j->h};
    // SDL_SetRenderDrawColor(pincel, 255, 255, 255, 255);
    // SDL_RenderFillRect(pincel, &jugador);
    // // Dibuja al cuadrado rojo
    // SDL_Rect rojo = {j->rojo_x, j->rojo_y, j->rojo_w, j->rojo_h};
    // SDL_SetRenderDrawColor(pincel, 255, 50, 50, 255);
    // SDL_RenderFillRect(pincel, &rojo);
    // // Dibuja la puntuación
    // char texto[50];
    // snprintf(texto, sizeof(texto), "Puntuacion: %d", j->puntuacion);
    // SDL_Superficie *sur = TTF_RenderText_Solid(fuente, texto, (SDL_Color){255, 255, 255});
    // SDL_Texture *textura = SDL_CreateTextureFromSurface(pincel, sur);
    // SDL_Rect dst = {10, 10, sur->w, sur->h};
    // SDL_RenderCopy(pincel, textura, NULL, &dst);
    // SDL_FreeSurface(sur);
    // SDL_DestroyTexture(textura);
    // // Dibuja el tiempo restante
    // int ticks_actuales = SDL_GetTicks();
    // int tiempo_restante = TIEMPO_JUEGO - (ticks_actuales - j->ticks_inicio);
    // if (tiempo_restante > 0) {
    //     char tiempo_texto[50];
    //     snprintf(tiempo_texto, sizeof(tiempo_texto), "Tiempo: %d", tiempo_restante / 1000);
    //     sur = TTF_RenderText_Solid(fuente, tiempo_texto, (SDL_Color){255, 255, 255});
    //     textura = SDL_CreateTextureFromSurface(pincel, sur);
    //     dst = {10, 40, sur->w, sur->h};
    //     SDL_RenderCopy(pincel, textura, NULL, &dst);
    //     SDL_FreeSurface(sur);
    //     SDL_DestroyTexture(textura);
    // }
    // SDL_RenderPresent(pincel);
}

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) { printf("ERROR SDL: %s\n", SDL_GetError()); return 1; }
    if (TTF_Init() < 0) { printf("ERROR TTF: %s\n", TTF_GetError()); return 1; }

    TTF_Font *fuente = TTF_OpenFont("fuente_principal.ttf", 24);
    if (!fuente) { printf("ERROR cargando fuente: %s\n", TTF_GetError()); return 1; }

    SDL_Window *ventana = SDL_CreateWindow("Mini Juego SDL2", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, ANCHO, ALTO, 0);
    SDL_Renderer *pincel = SDL_CreateRenderer(ventana, -1, SDL_RENDERER_ACCELERATED);

    srand((unsigned int)time(NULL));

    Juego j;
    inicializar_juego(&j);

    int corriendo = 1;
    SDL_Event e;
    Uint32 frameStart;
    int frameTime;

    while (corriendo) {
        frameStart = SDL_GetTicks();

        procesar_eventos(&j);
        actualizar_juego(&j);
        dibujar_juego(&j, fuente);

        frameTime = SDL_GetTicks() - frameStart;
        if (frameTime < FRAME_DELAY) {
            SDL_Delay(FRAME_DELAY - frameTime);
        }
    }

    TTF_CloseFont(fuente);
    SDL_DestroyRenderer(pincel);
    SDL_DestroyWindow(ventana);
    TTF_Quit();
    SDL_Quit();
    return 0;
}
C

gcc juego-mini.c $(sdl2-config --cflags --libs) -lSDL2_ttf -o juego-mini -lm
./juego-mini