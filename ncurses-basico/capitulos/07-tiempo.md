# 7. Tiempo, animación y refresco

## Objetivo

Al terminar este capítulo sabrás que un programa de ncurses avance solo, paso a paso, sin quedarse bloqueado esperando una tecla y sin quemar la CPU.

## Mapa del capítulo

- Por qué `getch()` se queda esperando para siempre
- `timeout(ms)`, `nodelay(win, TRUE)` y `halfdelay(t)`
- La regla de oro del bucle: comprueba `ERR`
- Patrón doble: avanza con tecla **o** con tick
- `napms(ms)`: dormir sin ocupar la CPU
- El orden de dibujo de cada frame
- Cómo las pruebas avanzan sin esperar

## getch() espera para siempre

`getch()` sin más no devuelve nada hasta que pulses una tecla. En una animación eso es un bloqueo: el programa se para y no dibuja nada más.

La solución es ponerle un límite de espera. Hay tres formas:

| Función | Espera | Devuelve si no hay tecla |
|---|---|---|
| `timeout(50)` | 50 milisegundos | `ERR` |
| `nodelay(stdscr, TRUE)` | 0: no espera | `ERR` al instante |
| `halfdelay(5)` | 5 décimas de segundo | `ERR` |

Las tres se llaman una vez, antes del bucle. Cambian el comportamiento de `getch()`:

```c
timeout(50);            // espera hasta 50 ms
int tecla = getch();    // devuelve ERR si en 50 ms no llega nada
```

**Regla: `timeout(ms)` convierte a `getch()` en un reloj.** Si no sabes qué elegir, usa `timeout`.

## La regla de oro del bucle

El bucle de animación comprueba siempre `ERR`. Si no llegó tecla, el programa **igual avanza**:

```c
timeout(1);
for (;;) {
    int t = getch();
    if (t == ERR) {
        avanzar_fisica();   // nadie tocó nada, pero el juego sigue
    } else {
        manejar_tecla(t);
    }
    refrescar();
}
```

**Si dentro del `if (t == ERR)` no ocurre nada, no tienes animación: tienes un menú.** El `ERR` es un tick: un latido que mueve el mundo aunque el usuario no toque nada.

## Patrón doble: tecla o tick

Muchos programas avanzan tanto con teclas como con ticks. En vez de dos caminos distintos, usa la tecla como tick extra:

```c
int t = getch();          // una tecla O un ERR
avanzar_fisica();         // el paso pasa siempre
if (t != ERR) aplicar(t); // y además la tecla hace su efecto
```

Con `timeout(1)`, una barra de progreso se llena sola; si el usuario pulsa teclas, esas teclas también mueven la barra. Un solo camino para los dos casos.

## napms(ms): dormir sin ocupar la CPU

`napms(20)` duerme el programa 20 ms sin consumir CPU. Útil entre frames cuando usas `nodelay`, que devuelve `ERR` al instante y no frena nada:

```c
if (getch() == ERR) avanzar_fisica();
napms(16);   // unos 60 frames por segundo
```

**Con `timeout(ms)` no hace falta `napms`:** el propio `getch()` ya espera ese tiempo.

## El orden de dibujo de cada frame

Cada frame sigue siempre el mismo orden:

1. Dibujar el estado nuevo.
2. `refresh()`.
3. `getch()` con timeout: el tick.
4. Actualizar el estado.
5. Borrar lo viejo y volver al paso 1.

**Nunca repintes toda la pantalla si puedes repintar una zona.** Y borra siempre lo viejo: si borras la celda anterior con un espacio antes de dibujar en la nueva, no quedan rastros.

## Cómo las pruebas avanzan sin esperar

En los ejercicios del curso, un bucle con `getch()` y `timeout(1)` avanza **un paso por getch()**, haga o no teclas. Con la entrada en pipe, cuando se acaba la entrada `getch()` devuelve `ERR` al instante: el bucle corre completo sin esperar nada. Por eso los tests son rápidos y deterministas.

Si tu solución espera 1 ms por paso y el bucle es de 20 pasos, el test tarda 20 ms, no 20 segundos.

## Errores típicos

- **El programa se congela al llegar al bucle:** `getch()` sin `timeout` ni `nodelay`. Arreglo: `timeout(ms)` antes del bucle.
- **La animación solo va si pulso teclas:** olvidaste comprobar `ERR` o dejaste el `if (t == ERR)` vacío. Arreglo: avanza la física también en `ERR`.
- **Usé `sleep(1)` y el programa dejó de reaccionar:** `sleep` bloquea el proceso entero; no lee teclas mientras duerme. Arreglo: `timeout`/`napms`, que dejan paso a `getch()`.
- **Quedan rastros al mover cosas:** dibujaste encima sin borrar. Arreglo: escribe un espacio en la celda vieja (o `mvhline` con espacios) antes de dibujar la nueva.
- **La terminal parpadea:** repintas toda la pantalla cada frame. Arreglo: repinta solo la zona que cambió.

## Resumen en 5 puntos

- `getch()` normal bloquea para siempre; `timeout(ms)`, `nodelay(win, TRUE)` y `halfdelay(t)` lo hacen devolver `ERR`.
- En el bucle de animación, `ERR` es un tick: compruébalo y avanza igualmente.
- `timeout(1)` + bucle = animación rápida; la tecla del usuario puede ser un tick más.
- `napms(ms)` duerme sin CPU; útil con `nodelay`.
- Dibuja, refresca, espera el tick, actualiza, borra lo viejo. Repinta solo zonas.

## Qué vas a practicar

- **Barra de progreso:** un instalador que avanza una celda por tick y termina al 100% (`barra-de-progreso`).
- **Cuenta atrás:** un temporizador con barra que vacía la pantalla al llegar a 0 (`cuenta-atras`).
