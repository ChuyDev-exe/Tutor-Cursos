# 7. Cargar e mostrar imágenes con SDL2_image

En este capítulo aprenderás a cargar y mostrar imágenes en tu ventana SDL2 usando SDL2_image, una extensión de SDL2 que agrega soporte para formatos de imagen populares como PNG, JPG y BMP.

## Qué aprenderás

- Cómo inicializar y usar `SDL2_image` junto con SDL2.
- Cómo cargar imágenes en formatos PNG, JPG y BMP con `IMG_Load`.
- Cómo convertir una superficie de imagen en una textura con `SDL_CreateTextureFromSurface`.
- Cómo dibujar la imagen en la pantalla con `SDL_RenderCopy`, incluyendo recorte y posición.
- Cómo liberar correctamente los recursos de imagen (superficie y textura).
- Cómo trabajar con "sprites" recortando porciones específicas de una imagen grande.

## Flujo básico para cargar y mostrar una imagen

1. `SDL_Superficie *superficie = IMG_Load("ruta/imagen.png");` — carga la imagen a la memoria.
2. `SDL_Texture *textura = SDL_CreateTextureFromSuperficie(renderer, superficie);` — pasa la superficie a la GPU.
3. `SDL_FreeSuperficie(superficie);` — libera la superficie (ya no la necesitamos en la GPU).
4. `SDL_RenderCopy(renderer, textura, NULL, &rect);` — dibuja la textura en la ventana.
5. `SDL_DestroyTextura(textura);` — libera la textura al terminar.

## Ojos comunes (TDAH-friendly)

- **Imagen no se carga:** Verifica la ruta y que el formato sea compatible (PNG, JPG, BMP son los más comunes). Recuerda que los archivos deben estar en la misma carpeta que el ejecutable o ruta absoluta.
- **La imagen aparece en blanco o con fondo extraño:** Prueba con `SDL_SetRenderDrawBlendMode` o asegúrate de que el área de recorte (`rect`) tenga el tamaño correcto.
- **Olvidas liberar la superficie:** Siempre llama a `SDL_FreeSuperficie()` después de crear la textura, o tendrás fugas de memoria.
- **La imagen muy grande o pequeña:** Ajusta el campo `w` y `h` del `SDL_Rect` en `SDL_RenderCopy` para escalar la imagen.

## Cargar imágenes desde recursos del proyecto

En los ejercicios de este curso incluimos una imagen de muestra (`imagen_jugador.png`) en cada ejercicio. Colócala en la carpeta `ejercicios/` de tu proyecto ycargo con:

```c
SDL_Superficie *superficie = IMG_Load("imagen_jugador.png");
if (!superficie) { printf("ERROR: %s\n", IMG_GetError()); return 1; }
```

## Bucle con imagen animada

Puedes cambiar el rectángulo de origen para crear animaciones de sprite:

```c
SDL_Rect src_rect = {0, 0, 32, 32};  // primera celda
SDL_Rect dst_rect = {x, y, 64, 64};  // posición y tamaño en pantalla
SDL_RenderCopy(renderer, textura, &src_rect, &dst_rect);
```

Al cambiar `src_rect.x` y `src_rect.y` puedes animar un personaje caminando.

---

**Listo.** Pasemos al ejercicio práctico.