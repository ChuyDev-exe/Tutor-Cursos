# Visor de informe

Completa la función `ver_informe` del script. El andamiaje ya ha creado un pad de 30 líneas (`linea 01` … `linea 30`) y lo ha escrito entero. Tu función pinta en pantalla un viewport de 5 filas por 15 columnas y deja desplazarse por el informe con el teclado, como `less` o `man`.

Edita solo la función marcada con `TODO`.

## Qué debe hacer `ver_informe`

1. Poner `*top` a 0 y pintar el viewport la primera vez con `prefresh(pad, *top, 0, 0, 0, 4, 14)`.
2. Leer teclas con `getch()` en un bucle hasta `q` o hasta `ERR` (fin de la entrada).
3. `j` o `KEY_DOWN` baja una línea: `*top` suma 1, pero nunca más de 25 (`30 - 5`).
4. `k` o `KEY_UP` sube una línea: `*top` resta 1, pero nunca menos de 0.
5. Tras cada tecla, volver a pintar con `prefresh`. **`wrefresh` no sirve en un pad.**

En una terminal real, con `keypad` activado, también funcionan las flechas; las pruebas usan `j` y `k`.

## Entrada
Teclas pulsadas, por ejemplo `jjk`. Si no hay nada, el visor se queda arriba del todo.

## Salida
El andamiaje imprime la fila del pad que se ve arriba y las dos líneas visibles en los bordes del viewport:

```
top=<fila del pad arriba>
v1=<línea visible en la fila 0 de pantalla>
v5=<línea visible en la fila 4 de pantalla>
```

## Ejemplo
Entrada: `jjj`  →  Salida:

```
top=3
v1=linea 04
v5=linea 08
```
