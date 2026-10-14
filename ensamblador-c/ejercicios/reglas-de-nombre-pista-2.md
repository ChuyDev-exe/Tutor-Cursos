Con `static` delante de la definición, cada archivo se queda con su propia versión: dos `static int dup` no producen `duplicate symbol`. Pónlo en los dos archivos, no en uno solo.
