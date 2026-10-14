# 3. Animaciones básicas con SDL2

En este capítulo aprenderás a crear animaciones simples. Veremos el concepto de "frames" y cómo mover objetos en el tiempo.

## Qué aprenderás

- Cómo usar `SDL_GetTicks()` para medir el tiempo transcurrido.
- Cómo cambiar el estado del juego según el tiempo (animación basada en tiempo, no en FPS).
- Cómo mover un rectángulo suavemente across la pantalla.
- El concepto de bucle de juego: procesar eventos → actualizar estado → dibujar.

## El concepto clave: animación basada en tiempo

Los computadores tienen velocidades diferentes. Usar `SDL_GetTicks()` te permite que la animación corra a la misma velocidad en cualquier computadora.

```c
int ticks = SDL_GetTicks(); // milisegundos desde que empezó el programa
```

Para mover un rectángulo a una velocidad de 100 píxeles por segundo:

```c
int velocidad = 100; // píxeles por segundo
int dx = (velocidad * ticks) / 1000; // cuántos píxeles mover este fotograma
```

## Bucle de juego completo

1. **Leer eventos** — ¿Cerró la ventana el usuario?
2. **Actualizar** — Actualiza la posición de los objetos según el tiempo.
3. **Dibujar** — Borra y dibuja todo en el nuevo estado.
4. **Presentar** — Muestra el resultado en la ventana.

## Ojos comunes (TDAH-friendly)

- **La animación va muy rápido o lento:** Usa `SDL_GetTicks()` para basar el movimiento en tiempo, no en cuántos FPS consigue el computador.
- **El rectángulo se sale de la pantalla:** Revisa los límites antes de mover (`if (x + w > 800) x = 800 - w`).
- **Olvidas borrar el fondo:** Siempre empieza con `SDL_RenderClear` antes de dibujar lo nuevo.

---

**Listo.** Ahora el ejercicio práctico.