Para partir `nombre,cantidad,precio` puedes usar `sscanf(filas[i], "%31[^,],%15[^,],%15s", nombre, cantidad, precio)`: `%[^,]` lee todo lo que hay hasta la siguiente coma.
