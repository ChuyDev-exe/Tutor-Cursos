En un fotograma pueden llegar varios eventos a la vez. Por eso `SDL_PollEvent` va dentro de un `while`, no de un `if`: el bucle termina cuando la cola está vacía.
