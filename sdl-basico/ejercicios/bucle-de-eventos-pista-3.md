Estructura casi completa:

```c
SDL_Event e;
while (SDL_PollEvent(&e)) {
    if (e.type == SDL_QUIT) {
        *corriendo = 0;
    } else if (e.type == SDL_KEYDOWN) {
        switch (e.key.keysym.sym) {
            case SDLK_RIGHT: jugador->x += PASO; break;
            // … las otras tres flechas
            default: break;
        }
    }
}
```
