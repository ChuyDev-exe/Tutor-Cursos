# Cuenta atrás

Un temporizador tipo pomodoro: muestra cuántos segundos quedan y una barra que se va vaciando. Completa la función `cuenta_atras`.

La pantalla mide 6 filas por 30 columnas:

```
quedan  5 s                       ← fila 1
                                  ← fila 2
#####                             ← fila 3 (barra: una # por segundo)
```

Cuando llega a 0, la barra queda vacía y la fila 1 dice `¡Tiempo!`.

## Pasos

1. Si `segundos <= 0`, escribe `¡Tiempo!` en la fila 1, columna 1, refresca y termina sin bucle.
2. Llama a `timeout(1)` para que `getch()` no bloquee.
3. Bucle descendente: `restante` desde `segundos` hasta 0. En cada vuelta:
   - `mvprintw(1, 1, "quedan %2d s", restante)`
   - borra la barra vieja con `mvhline(3, 1, ' ', COLS - 1)` y dibuja `restante` celdas `#` en la fila 3 desde la columna 1. **No te salgas de la pantalla**: no pintes si `1 + i >= COLS`.
   - `refresh()` y `getch()` como tick (la tecla no cambia nada).
4. Al terminar: borra la barra con espacios, borra `quedan 0 s` con `mvhline(1, 1, ' ', 12)`, escribe `¡Tiempo!` en la fila 1, columna 1 y refresca.

## Entrada
Una línea con los segundos (1..99). Si no hay número, se cuenta desde 0 y el rótulo final aparece directo.

## Salida
El andamiaje recoge la fila 1 y la fila 3:

```
mensaje=<fila 1 desde la columna 1, recortada>
barra=<fila 3 desde la columna 1, recortada>
restante=<los # que queden en la barra>
```

## Ejemplo
Entrada: `5\n`  →  Salida:

```
mensaje=¡Tiempo!
barra=
restante=0
```

Edita solo la función marcada con `TODO`.
