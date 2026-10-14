# 8. Sonido y música con SDL2_mixer

En este capítulo aprenderás a agregar efectos de sonido y música a tus juegos SDL2 usando SDL2_mixer, una extensión de SDL2 para manejo de audio.

## Qué aprenderás

- Cómo inicializar `SDL2_mixer` y los formatos de audio compatibles.
- Cómo cargar efectos de sonido temporales (WAV) con `Mix_LoadWAV`.
- Cómo cargar música para reproducir largo metraje (MP3, OGG) con `Mix_LoadMUS`.
- Cómo reproducir sonido y música con `Mix_PlayChannel` y `Mix_PlayMusic`.
- Cómo establecer el volumen de canales y música con `Mix_VolumeChunk` y `Mix_VolumeMusic`.
- Cómo liberar los recursos de audio (`Mix_FreeChunk`, `Mix_FreeMusic`) para evitar fugas de memoria.
- Cómo mezclar múltiples sonidos y controlar la superposición.

## Inicializar SDL2_mixer

Antes de usar cualquier función de SDL2_mixer, debes inicializarla:

```c
int flags = MIX_INIT_OGG | MIX_INIT_MP3;
int inited = Mix_Init(flags);
if (inited < flags) {
    printf("Warning: mezcla de init no completa: %s\n", Mix_GetError());
}
```

Luego abre el sistema de audio:

```c
if (Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0) {
    printf("ERROR audio: %s\n", Mix_GetError());
    return 1;
}
```

## Efectos de sonido vs Música

| Concepto | Función | Tipo de dato | Uso típico |
|----------|---------|--------------|------------|
| Efecto de sonido | `Mix_LoadWAV()` | `Mix_Chunk` | Disparos, saltos, colisiones. Corto, se carga entero en memoria. |
| Música | `Mix_LoadMUS()` | `Mix_Music` | Fondo, tema principal, largo metraje. Streaming, no carga todo en RAM. |

## Reproducir sonido

```c
Mix_Chunk *explosion = Mix_LoadWAV("explosion.wav");
if (explosion) {
    Mix_PlayChannel(-1, explosion, 0);  // -1 = cualquier canal disponible
    // O con canal específico: Mix_PlayChannel(0, explosion, 0);
}
```

**Nota:** `-1` como número de canal usa el primer canal disponible. El tercer parámetro es bucles (-1 = infinito, 0 = una sola vez).

## Reproducir música

```c
Mix_Music *fondo = Mix_LoadMUS("fondo.mp3");
if (fondo) {
    Mix_PlayMusic(fondo, -1);  // -1 = bucle infinito
    // o Mix_PlayMusic(fondo, 1) para reproducir 1 vez
}
```

## Control de volumen

```c
// Volumen de un efecto (0 = silencio, 128 = máximo)
Mix_VolumeChunk(explosion, 64);  // 50% de volumen

// Volumen de la música (0 = silencio, 128 = máximo)
Mix_VolumeMusic(96);  // 75% de volumen
```

## Liberar recursos

```c
Mix_FreeChunk(explosion);   // Libera el efecto de sonido
Mix_FreeMusic(fondo);       // Libera la música
Mix_CloseAudio();           // Cierra el subsistema de audio
Mix_Quit();                 // Sale de SDL2_mixer
```

## Ojos comunes (TDAH-friendly)

- **No hay sonido:** Verifica que hayas llamado a `Mix_OpenAudio()` antes de cargar nada. Sin esto, las funciones de mixer fallarán silenciosamente.
- **El sonido se corta o choca:** Los canales son limitados (8 por defecto). Si reproduces muchos sonidos rápidos en el mismo canal, se sobrescribirá. Usa `-1` para cualquier canal disponible.
- **La música no reproduce:** Asegúrate de usar `Mix_LoadMUS()` no `Mix_LoadWAV()` para archivos MP3/OGG largos. `Mix_LoadWAV` carga todo en memoria y puede consumir toda la RAM.
- **Olvidas liberar:** Siempre llama a `Mix_FreeChunk` y `Mix_FreeMusic` al terminar, y `Mix_CloseAudio()` antes de `SDL_Quit()`.

---

**Listo.** Pasemos al ejercicio práctico.