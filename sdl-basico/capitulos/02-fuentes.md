# 2. Fuentes y texto con SDL2

En este capítulo aprenderás a mostrar texto en una ventana SDL2. Usaremos SDL_ttf, una biblioteca auxiliar que viene instalada con SDL2 en este curso.

## Qué aprenderás

- Cómo cargar una fuente con `TTF_OpenFont`
- Cómo crear una superficie de texto con `TTF_RenderText_Solid`
- Cómo convertir la superficie en una textura con `SDL_CreateTextureFromSurface`
- Cómo liberar los recursos cuando ya no los necesites

## El flujo básico

1. `TTF_Font *fuente = TTF_OpenFont("ruta/arial.ttf", 24);` — carga la fuente y el tamaño.
2. `SDL_Superficie *superficie = TTF_RenderText_Solid(fuente, "Hola SDL", color);` — dibuja el texto en una superficie.
3. `SDL_Texture *textura = SDL_CreateTextureFromSurface(renderer, superficie);` — pasa la superficie a la GPU.
4. `SDL_FreeSurface(superficie);` y `TTF_CloseFont(fuente);` — libera la memoria.

## Ojos comunes (TDAH-friendly)

- **Fuente no carga:** Verifica que la ruta sea correcta y el archivo exista. En los ejercicios usaremos una fuente incluida.
- **Texto en blanco:** Revisa el color que pasas a `TTF_RenderText_Solid`. El blanco es `{255, 255, 255}`.
- **Olvidar liberar:** Siempre llama a `TTF_CloseFont` y `SDL_FreeSurface` al terminar, o tendrás fugas de memoria.

## Paleta de colores rápida

Los colores son structs `SDL_Color` con los campos `r, g, b` (0-255) y `a` (alfá, opcional).

| Color | r | g | b |
|-------|---|---|---|
| Blanco | 255 | 255 | 255 |
| Negro | 0 | 0 | 0 |
| Rojo | 255 | 0 | 0 |
| Verde | 0 | 255 | 0 |
| Azul | 0 | 0 | 255 |

---

**Listo.** Pasemos al ejercicio práctico.