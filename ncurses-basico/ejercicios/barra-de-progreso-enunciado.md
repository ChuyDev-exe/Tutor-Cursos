# Barra de progreso

Un instalador de verdad muestra una barra que se llena celda a celda. Completa la función `instalar`: dibuja una barra de 20 `#` en la fila 2, una por paso, y al final escribe `100%` en la fila 0.

La pantalla mide 5 filas por 30 columnas y la barra empieza en la columna 2:

```
100%                              ← fila 0 (al terminar)
                                  ← fila 1
  ####################            ← fila 2 (barra completa)
                                  ← fila 3
                                  ← fila 4
```

## Pasos

1. Llama a `timeout(1)` al principio: `getch()` deja de bloquear y espera como mucho 1 ms.
2. Repite 20 veces: dibuja un `#` en la celda `(2, 2 + paso)`, llama a `refresh()` y luego a `getch()`.
3. `getch()` **no se usa para nada más**: la tecla (o `ERR` si no llega ninguna) solo avanza el paso. Así el avance es el mismo con o sin teclas.
4. Cuando el bucle termina, escribe `100%` en la fila 0, columna 0 y refresca.

La andamiaje ya puso `cbreak()` y `noecho()` antes de llamarte.

## Entrada
Puede venir cualquier cosa: teclas, saltos de línea o nada (entonces cada `getch()` devuelve `ERR` al instante).

## Salida
El andamiaje recoge la fila 2 y cuenta los `#`:

```
barra=<las 20 celdas de la barra, desde la columna 2>
paso_final=<cuántos # hay>
```

## Ejemplo
Entrada: `xxxxxxxxxxxxxxxxxxxx` (20 teclas basura)  →  Salida:

```
barra=####################
paso_final=20
```

Con entrada vacía la salida es la misma: los `ERR` también son ticks.

Edita solo la función marcada con `TODO`.
