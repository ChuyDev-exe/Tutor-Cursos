# 6. Aplicaciones completas SDL2

En este capítulo unirás todo lo que aprendiste: ventana, eventos, renderizado, texto, animación y 3D básico. Construiremos un pequeño juego completo desde cero.

## Qué aprenderás

- Cómo organizar un proyecto SDL2 con múltiples archivos y recursos.
- Cómo cargar y gestionar recursos (fuentes, texturas) al inicio y liberarlos al terminar.
- Cómo crear un estado de juego que tenga menú, juego activo y Game Over.
- Cómo combinar entradas de teclado y mouse en un mismo bucle.
- Buenas prácticas: bucle a velocidad fija, delta time, limpieza de recursos.

## Estructura de una aplicación SDL2 completa

```text
1. Inicializar SDL, ventana, renderer, TTF
2. Cargar recursos: fuentes, texturas, sonidos (si están)
3. Bucle principal:
   - Calcular delta time (tiempo desde fotograma anterior)
   - Procesar eventos (teclado, mouse, cierre)
   - Actualizar juego (posición, IA, colisiones)
   - Dibujar todo (borrar, dibujar objetos, texto en pantalla)
   - Presentar el resultado
4. Liberar recursos y cerrar SDL
```

## Bucle a velocidad fija (importante)

En lugar de correr "lo más rápido que sea posible", es mejor actualizar a una tasa fija:

```c
const int FPS = 60;
const int FRAME_DELAY = 1000 / FPS;

Uint32 frameStart;
int frameTime;

while (corriendo) {
    frameStart = SDL_GetTicks();

    // 1. Procesar eventos
    // 2. Actualizar juego con delta time
    // 3. Dibujar
    // 4. Limitar FPS
    frameTime = SDL_GetTicks() - frameStart;
    if (frameTime < FRAME_DELAY) {
        SDL_Delay(FRAME_DELAY - frameTime);
    }
}
```

## Recursos en el curso

Usaremos una fuente incluida en cada ejercicio (`fuente_principal.ttf`). Para cargarla:

```c
TTF_Font *fuente = TTF_OpenFont("fuente_principal.ttf", 24);
if (!fuente) { printf("ERROR: %s\n", TTF_GetError()); return 1; }
```

Siempre recuerda cerrarla al final: `TTF_CloseFont(fuente);`

## Ojos comunes (TDAH-friendly)

- **Memoria llena:** Si el programa va lento después de un rato, revisa que estés liberando fuentes, texturas y ventanas con `TTF_CloseFont`, `SDL_DestroyTexture`, `SDL_DestroyWindow`.
- **El texto parpadea:** Borra siempre el fondo antes de dibujar el texto nuevo en cada fotograma.
- **El juego va muy rápido en computadoras potentes:** Usa el límite de FPS mostrado arriba.

---

**¡Felicidades!** Has completado todo el curso. Ahora puedes crear programas básicos con SDL2, mostrar texto, animar objetos y manejar eventos.