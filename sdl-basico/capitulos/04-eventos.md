# 4. Manejo de eventos y callbacks en SDL2

En este capítulo aprenderás a responder a la entrada del usuario de manera estructurada. Veremos eventos teclado, mouse y callbacks(funciones de callback).

## Qué aprenderás

- Cómo procesar diferentes tipos de eventos (`SDL_KEYDOWN`, `SDL_KEYUP`, `SDL_MOUSEBUTTONDOWN`, `SDL_MOUSEBUTTONUP`).
- Cómo usar callbacks para separar la lógica de "qué pasa" de "cómo se maneja".
- Cómo leer el estado actual del teclado con `SDL_GetKeyboardState`.
- Cómo manejar eventos de ratón para interactuar con objetos en la pantalla.

## Estructura de eventos

Cada fotograma del bucle de juego debes vaciar la cola de eventos:

```c
while (SDL_PollEvent(&e) != 0) {
    switch (e.type) {
        case SDL_QUIT:
            corriendo = 0;
            break;
        case SDL_KEYDOWN:
            // Algo se presionó
            break;
        case SDL_KEYUP:
            // Algo se soltó
            break;
        case SDL_MOUSEBUTTONDOWN:
            // Se hizo clic
            break;
    }
}
```

## Callbacks (funciones de callback)

Un callback es una función que pasas como argumento para que sea llamada más tarde. En SDL2 es útil para:

- Manejadores de entrada
- Temporizadores
- Complej de carga de recursos

```c
void manejar_tecla(SDL_Keycode tecla) {
    if (tecla == SDLK_LEFT) x -= VELOCIDAD;
    if (tecla == SDLK_RIGHT) x += VELOCIDAD;
}
```

Luego en el evento:
```c
case SDL_KEYDOWN:
    manejar_tecla(e.key.keysym.sym);
    break;
```

## Ojos comunes (TDAH-friendly)

- **Tecla repetida:** `SDL_KEYDOWN` se dispara cada vez que el sistema vuelve a enviar el evento mientras mantienes la tecla pulsada. Si quieres solo una vez, usa una bandera `bool tecla_presionada = false;` y vérificala.
- **Coordenadas del ratón:** `e.button.x` y `e.button.y` son coordenadas relativas a la ventana. Si redimensionas, pueden ser inesperadas.
- **Olvidas `SDL_PollEvent`:** Si no la llamas, la cola se llena y el programa deja de responder.

---

**Listo.** Pasemos al ejercicio práctico.