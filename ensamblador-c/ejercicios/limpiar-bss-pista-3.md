Ojo con el orden: si pones el `ret` al principio, la función no hace nada y la segunda línea contará los `n` bytes sin limpiar. Prueba con `n` igual a 8 y comprueba que la segunda línea es 0.
