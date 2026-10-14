# Mini juego: Captura el cuadrado

Completa un pequeño juego donde el jugador controla un cuadrado blanco con las flechas del teclado y debe atrapar un cuadrado rojo que se mueve solos. El juego tiene 30 segundos de duración.

Edita las funciones marcadas con `TODO` en el archivo `juego-mini-plantilla.sh`.

## Objetivo

Atrapar el cuadrado rojo con el cuadrado blanco. Cada vez que se superponen, sumaste 10 puntos y el cuadrado rojo se teletransporta a una posición aleatoria.

## Elementos del juego

1. **Cuadrado del jugador:** Empez en `(400, 500)`, mide `50x30`, se mueve con flechas (5 píxeles por pulsación).
2. **Cuadrado objetivo:** Empez en posición aleatoria en la parte superior, mide `30x30`, se mueve sola a velocidad aleatoria.
3. **Puntuación:** Empieza en 0, aumenta en 10 por cada captura.
4. **Tiempo:** El juego dura 30 segundos. Cuando termine, muestra "Juego terminado: Puntuación X".

## Funciones que debes completar

1. `inicializar_juego()` — Inicializa posiciones, velocidades, puntuación, tiempo inicial. Genera la primera posición aleatoria del cuadrado rojo.
2. `procesar_eventos()` — Vacía la cola de eventos. Si se cierra la ventana, poner `corriendo = 0`. Si se presiona una flecha, mover al cuadrado del jugador (5 píxeles). Usa una función callback para moverse.
3. `actualizar_juego(ticks)` — Actualiza la posición del cuadrado rojo según su velocidad. Si choca con los bordes, invierte dirección. Verifica choque con el cuadrado del jugador (usando `SDL_HasIntersection`). Si hay choque, suma puntos y reubica el rojo aleatoriamente. Reduce el tiempo restante.
4. `dibujar_juego(ticks)` — Borra pantalla, dibuja al cuadrado blanco, al cuadrado rojo, la puntuación actual (usando lo visto en el capítulo de fuentes) y el temporizador.

## Salida

Ventana con el juego en tiempo real. Al terminar los 30 segundos, se muestra el mensaje final y el programa cierra automáticamente.

## Ejemplo

Después de 10 segundos, si atrapaste 3 cuadrados rojos: muestra "Puntuación: 30" en la parte superior izquierda.