# Serpiente determinista

Estás construyendo el capstone del curso: una partida de snake completa y **reproducible**. A diferencia de un juego normal, aquí no hay `getch` dentro de `jugar`: el andamiaje te entrega ya una cadena de teclas y tu función la procesa carácter a carácter, un carácter = un paso. Las mismas teclas producen siempre la misma partida, por eso las pruebas pueden comprobarla al detalle.

La rejilla mide 10 filas (`ALTO`) por 20 columnas (`ANCHO`). La serpiente empieza con 3 segmentos: cabeza en (5, 5), y el cuerpo hacia la izquierda: (5, 4) y (5, 3). Hay 3 comidas, en este orden: (5, 8), (2, 2) y (7, 15). Coordenadas como siempre: fila primero, columna después.

## Teclas

| Tecla | Efecto |
|---|---|
| `w` / `KEY_UP` | dirección arriba |
| `s` / `KEY_DOWN` | dirección abajo |
| `a` / `KEY_LEFT` | dirección izquierda |
| `d` / `KEY_RIGHT` | dirección derecha |
| `q` | termina la partida (no mueve) |
| otra | se ignora (no mueve) |

**No se puede girar 180°:** si va a la derecha, la tecla `a` se ignora por completo (ni gira ni mueve), y viceversa; lo mismo con arriba/abajo. Excepción: **la primera tecla válida de la partida fija la dirección inicial**, aunque sea `a` (y entonces da un paso a la izquierda). La partida empieza yendo a la derecha. En las pruebas solo llegan letras; en una terminal real, con `keypad`, llegarían también las flechas.

## Qué debe hacer `jugar`

Cada tecla válida da **un paso**, en este orden:

1. Nueva cabeza: `ny = hy + diry`, `nx = hx + dirx`.
2. ¿Pared? `ny < 0 || ny >= ALTO || nx < 0 || nx >= ANCHO` → `*vivo = 0` y terminas. **La cabeza se queda en la posición del choque** (puede ser negativa o igual a 10): es el diagnóstico del crash.
3. ¿Auto-choque? si `(ny, nx)` coincide con `segmentos[1]` … `segmentos[largo-1]` (el cuerpo, sin la cabeza) → `*vivo = 0`, la cabeza se queda en la posición del choque y terminas.
4. ¿Comió? si la nueva cabeza está en `comidas[comida_idx]`: `(*score)++`, `comida_idx++` y **ese paso el animal crece** (`(*largo)++`; la cola NO se descarta). Si no comió, la cola se pierde al desplazar.
5. Actualiza el estado: recorre desde `*largo - 1` hasta 0 haciendo `segmentos[s + 1] = segmentos[s]`, pon la cabeza nueva en `segmentos[0]` y actualiza `*hy`, `*hx`.

## Entrada

Una línea con las teclas de la partida, por ejemplo `ddd`. Si no hay nada, no hay pasos: la serpiente se queda donde empezó.

## Salida

El andamiaje dibuja el estado final (`@` cabeza, `o` cuerpo, `*` comida pendiente) e imprime:

```
score=<puntuación> largo=<segmentos> estado=<vivo|muerto> cabeza=<fila>,<columna>
```

## Ejemplo

Entrada: `ddd`  →  Salida:

```
score=1 largo=4 estado=vivo cabeza=5,8
```

Edita solo la función marcada con `TODO`.
