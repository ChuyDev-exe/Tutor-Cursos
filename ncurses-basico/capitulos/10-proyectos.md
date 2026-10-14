# 10. Proyectos: de la librería al juego

## Objetivo

Al terminar este capítulo sabrás montar un juego completo: guardar el estado en structs y arrays, moverlo con un bucle de teclas, detectar colisiones y evolucionar una simulación celda a celda.

## Mapa del capítulo

- Estado del juego en structs y arrays
- El bucle de un juego: tecla → mover → comprobar → dibujar
- Colisiones: pared y auto-choque
- Borrar el rabo para no dejar rastros
- Conway: dos matrices, nunca mutar en sitio
- Qué te falta por aprender (y dónde está)

## El estado del juego vive en structs y arrays

Un juego es un montón de datos que cambian: la posición de cada segmento, la comida, la dirección, la puntuación. Guárdalos en structs y arrays, como en el capítulo 9:

```c
typedef struct { int y; int x; } Punto;
Punto segmentos[64];   // segmentos[0] es la cabeza
int largo, score;      // y el resto del estado...
```

**Regla de oro: el estado es dato, no dibujo.** La función del juego actualiza el estado; dibujar es una fase aparte al final de cada paso.

## El bucle de un juego por teclas

Cada tecla es un paso (sin temporizador, como en los ejercicios del capítulo 7 con `timeout` lo harías en tiempo real):

```c
tecla = getch();
if (tecla == 'd') dirx = 1, diry = 0;      // 1) nueva dirección
ny = hy + diry; nx = hx + dirx;            // 2) nueva cabeza
if (choca_pared(ny, nx)) vivo = 0;         // 3) ¿chocó?
else if (ny == cy && nx == cx) score++;    // 4) ¿comió?
```

**Orden de un paso: dirección → cabeza → pared → comida → cuerpo → actualizar.** Sigue siempre el mismo orden: si lo cambias, aparecen bugs que no se ven.

## Colisiones: pared y auto-choque

Dos comprobaciones distintas, ambas obligatorias:

```c
if (y < 0 || y >= ALTO || x < 0 || x >= ANCHO) vivo = 0;   // pared
for (int i = 1; i < largo; i++)                             // cuerpo
    if (segmentos[i].y == y && segmentos[i].x == x) vivo = 0;
```

**La pared se compara con los límites de la rejilla; el cuerpo, con un bucle sobre los segmentos (sin contar la cabeza).** Al morir, la cabeza se queda en la posición del choque: es el diagnóstico del crash.

## Borra el rabo al mover

Si la serpiente no come, la cola desaparece: escribe un espacio en la celda de la cola antigua antes de dibujar. Si come, la cola **no** se borra y el animal crece.

| ¿Comió? | Largo | Rabo |
|---|---|---|
| no | igual | se borra (la celda queda libre) |
| sí | +1 | se queda donde está |

**Si olvidas borrar la cola, dejas un rastro de `o` por la pantalla.** En el modelo es el mismo caso: si no comió, descartas el último segmento al desplazar.

## Conway: dos matrices, nunca mutar en sitio

El Juego de la Viva tiene una regla por celda: cuenta los vecinos vivos de las 8 celdas alrededor. Viva con 2 o 3 vecinos sigue viva; muerta con exactamente 3 nace; todo lo demás muere o sigue muerto.

```c
for (int f = 0; f < filas; f++)
    for (int c = 0; c < columnas; c++) {
        int v = contar_vecinos(g, f, c);        // lee g, no destino
        destino[f][c] = (v == 3 || (viva && v == 2)) ? '#' : '.';
    }
memcpy(g, destino, sizeof g);                   // y solo al acabar
```

**Regla de oro: escribe en una matriz destino y copia al final.** Si mutas `g` mientras cuentas, las celdas que procesas antes cambian las que procesas después. Los bordes de la matriz cuentan como muertos: nunca leas fuera de `0 .. filas-1`.

## Qué te falta por aprender

Con los capítulos 1 a 9 ya sabes casi todo. Lo que separa tu juego del «verdadero»:

| Pieza | Dónde está |
|---|---|
| Moverse sin pulsar teclas (`timeout`) | capítulo 7 |
| Colores (comida roja, serpiente verde) | capítulo 3 |
| HUD en ventanas propias (marcador, ayuda) | capítulo 4 |
| Pads para listas de récords largas | capítulo 5 |

## Errores típicos

- **Mutas la matriz mientras cuentas vecinos.** Arreglo: cuenta sobre `g`, escribe en `destino`, copia al final.
- **Olvidas borrar el rabo.** Arreglo: si no comió, borra la celda de la cola antigua antes de dibujar.
- **Giras 180° y te comes la cola.** Arreglo: si va a la derecha, ignora la tecla `a` (y viceversa con las verticales).
- **Un array de tamaño fijo sin comprobar el índice.** Arreglo: comprueba `largo < capacidad` antes de añadir un segmento.
- **Dibujas encima sin borrar.** Arreglo: borra las celdas viejas o repinta la rejilla entera en cada paso.

## Resumen en 5 puntos

- El estado (segmentos, comida, dirección, score) es dato en structs y arrays; el dibujo va aparte.
- Un paso = dirección → nueva cabeza → pared → comida → cuerpo → actualizar arrays.
- Dos colisiones: pared con los límites de la rejilla, cuerpo con un bucle sobre los segmentos.
- Sin comida se borra la cola; con comida el largo crece.
- Conway se calcula en una matriz destino y se copia al final; nunca mutes en sitio.

## Qué vas a practicar

- **Serpiente determinista:** una partida completa reproducible a partir de una cadena de teclas, con comida, crecimiento y muerte por pared o por mordisco (`snake`).
- **Juego de la Vida:** una generación de Conway en matrices 6x12, con reglas de nacimiento y muerte y varias generaciones (`juego-de-la-vida`).
