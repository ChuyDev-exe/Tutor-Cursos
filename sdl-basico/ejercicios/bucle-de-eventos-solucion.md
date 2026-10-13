```bash
#!/usr/bin/env bash
set -euo pipefail

cat > bucle.c <<'C'
#include <SDL.h>
#include <stdio.h>

#define PASO 10

/* Procesa todos los eventos pendientes. Mueve al jugador con las flechas
   y pone *corriendo a 0 cuando llega SDL_QUIT. */
static void procesar_eventos(SDL_Rect *jugador, int *corriendo) {
    SDL_Event e;
    while (SDL_PollEvent(&e)) {
        if (e.type == SDL_QUIT) {
            *corriendo = 0;
        } else if (e.type == SDL_KEYDOWN) {
            switch (e.key.keysym.sym) {
                case SDLK_RIGHT: jugador->x += PASO; break;
                case SDLK_LEFT:  jugador->x -= PASO; break;
                case SDLK_DOWN:  jugador->y += PASO; break;
                case SDLK_UP:    jugador->y -= PASO; break;
                default: break;
            }
        }
    }
}

/* ---- Andamiaje del curso: no hace falta tocar nada de aquí hacia abajo ---- */

/* Convierte cada letra de la entrada en una pulsación de tecla
   (w, a, s, d → flechas) y al final añade un evento SDL_QUIT. */
static void simular_teclado(void) {
    int c;
    while ((c = getchar()) != EOF) {
        SDL_Keycode tecla = c == 'w' ? SDLK_UP : c == 's' ? SDLK_DOWN
                          : c == 'a' ? SDLK_LEFT : c == 'd' ? SDLK_RIGHT : SDLK_UNKNOWN;
        if (tecla == SDLK_UNKNOWN) continue;
        SDL_Event e;
        SDL_zero(e);
        e.type = SDL_KEYDOWN;
        e.key.keysym.sym = tecla;
        SDL_PushEvent(&e);
    }
    SDL_Event fin;
    SDL_zero(fin);
    fin.type = SDL_QUIT;
    SDL_PushEvent(&fin);
}

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    if (SDL_Init(SDL_INIT_EVENTS) != 0) {
        printf("SDL_Init: %s\n", SDL_GetError());
        return 1;
    }
    simular_teclado();

    SDL_Rect jugador = { 100, 100, 20, 20 };
    int corriendo = 1;
    int fotogramas = 0;
    while (corriendo && fotogramas < 100) {   /* límite de seguridad para las pruebas */
        procesar_eventos(&jugador, &corriendo);
        /* aquí un juego real dibujaría el fotograma */
        fotogramas++;
    }

    printf("x=%d y=%d\n", jugador.x, jugador.y);
    printf("salida: %s\n", corriendo ? "no" : "si");
    SDL_Quit();
    return 0;
}
C

gcc bucle.c $(sdl2-config --cflags --libs) -o bucle
./bucle
```

`SDL_PollEvent` saca un evento de la cola y devuelve 0 cuando está vacía; por eso va en un `while`. `SDL_QUIT` llega al cerrar la ventana y termina el bucle principal. Con `SDL_KEYDOWN`, `e.key.keysym.sym` dice qué tecla se pulsó. El eje y crece hacia abajo, así que la flecha de arriba **resta** a `y`.
