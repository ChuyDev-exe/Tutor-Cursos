El correo se valida con `strchr(correo, '@') != NULL`. Para la edad, recorre `edad_txt` con `isdigit` y convierte con `strtol(edad_txt, NULL, 10)`; recuerda descartar la edad vacía.
