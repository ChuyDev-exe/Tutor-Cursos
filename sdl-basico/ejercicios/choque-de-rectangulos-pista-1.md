SDL ya trae las dos operaciones que necesitas. Las dos reciben punteros a `SDL_Rect`: pasa `&a` y `&b`, no los rectángulos sin `&`.
