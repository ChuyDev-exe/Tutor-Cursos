# Reproducir un efecto de sonido

Completa el programa para cargar y reproducir un efecto de sonido (WAV) cuando se presiona la barra espaciadora. El sonido debe reproducirse en un canal disponible y el programa debe terminar después de 3 segundos.

Edita solo la parte marcada con `TODO`.

## Qué debe hacer tu código

1. Inicializar SDL2_mixer con `Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048)`.
2. Cargar el efecto de sonido `golpe.wav` usando `Mix_LoadWAV`.
3. En el bucle de eventos, detectar cuándo se presiona la tecla `SDLK_SPACE`.
4. Cuando se presiona espacio, reproducir el sonido con `Mix_PlayChannel(-1, golpe, 0)`.
5. Después de 3 segundos o al cerrar la ventana, terminar el programa.

## Entrada

Presiona la tecla `ESPACIO` (barra espaciadora) para reproducir el sonido.

## Salida

Al presionar espacio, se reproduce el efecto de sonido `golpe.wav` en un canal disponible. El programa continúa hasta los 3 segundos o hasta cerrar la ventana, momento en que termina.

## Ejemplo

Cuando presionas `ESPACIO`, escuchas un sonido de "golpe" y el programa sigue su curso normal.