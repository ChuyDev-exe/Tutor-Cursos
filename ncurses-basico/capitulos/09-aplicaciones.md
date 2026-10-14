# 9. Aplicaciones reales: datos, scroll y estado

## Objetivo

Al terminar este capítulo sabrás separar los datos del dibujo, cargar un fichero en memoria, mostrar una lista larga con scroll y mantener una barra de estado siempre al día.

## Mapa del capítulo

- Modelo y vista: dos piezas que no se mezclan
- El bucle de eventos: tecla → estado → repintar
- Cargar datos con `fopen` y `fgets`
- Barra de estado: una fila que cuenta dónde estás
- Scroll con desplazamiento y clamp
- Ordenar con `qsort`

## Modelo y vista: dos piezas separadas

Una TUI seria guarda los datos en memoria (el **modelo**) y tiene funciones que solo dibujan (la **vista**). El modelo puede ser un array de structs o un fichero ya cargado; la vista lo pinta en pantalla.

```c
typedef struct { char nombre[16]; int cantidad; } Producto;
Producto prod[8];            // el modelo: datos en memoria
dibujar_tabla(prod, 8);      // la vista: solo dibuja
```

**Regla de oro: el dibujo lee el modelo, nunca al revés.** Si en una función de dibujo aparece `getch()` o se modifican los datos, estás mezclando las dos piezas.

## El bucle de eventos

Toda aplicación interactiva repite lo mismo: leer una tecla, actualizar el estado y repintar solo lo que cambió.

```c
int tecla;
while ((tecla = getch()) != 'q' && tecla != ERR) {
    actualizar_estado(tecla);   // 1) lógica sobre el modelo
    repintar();                // 2) dibujo desde el modelo
    refresh();                 // 3) mostrar
}
```

**Orden fijo: leer → actualizar → repintar.** Nunca al revés: si dibujas antes de actualizar, siempre verás la pantalla un paso atrasada.

## Cargar datos de un fichero

Los datos reales viven en un fichero. Se cargan con `fopen`, se leen línea a línea con `fgets` y se separan con `sscanf` o `strtok`:

```c
FILE *f = fopen("datos.txt", "r");
if (!f) { endwin(); printf("no hay datos\n"); return 1; }
while (fgets(buf, sizeof buf, f))
    sscanf(buf, "%15s %d %d", nombre, &cant, &precio);
fclose(f);
```

**Tres reglas de oro:** comprueba que `fopen` no devolvió `NULL`, pasa siempre el tamaño del búfer a `fgets` y cierra el fichero con `fclose`.

## Barra de estado

Una fila fija de la pantalla (la primera o la última) resume el estado: posición, total, modo. Se repinta **cada vez que cambia algo**.

```c
mvprintw(LINES - 1, 0, "linea %d-%d de %d", top + 1, fin, n);
refresh();
```

**Si repintas el contenido y olvidas la barra, el usuario ve mentiras.** Dibuja las dos en el mismo sitio del bucle.

## Scroll con clamp

La ventana muestra un trozo del array: guardas un desplazamiento (`top`) y dibujas desde `lineas[top]`. La ventana no se mueve; se mueve el índice.

```c
if (tecla == 'j' && top < n - ALTO_VIS) top++;
if (tecla == 'k' && top > 0) top--;
```

**El clamp es obligatorio:** `top` va de 0 a `n - ALTO_VIS`. Sin él, el scroll se sale del array y dibujas basura o memoria que no es tuya.

## Ordenar con qsort

`qsort` de `<stdlib.h>` ordena un array con un comparador que devuelve `<0`, `0` o `>0`:

```c
int cmp(const void *a, const void *b) {
    return strcmp(((Producto *)a)->nombre, ((Producto *)b)->nombre);
}
qsort(prod, n, sizeof(Producto), cmp);   // ordena en el sitio
```

**`qsort` ordena in-place: destruye el orden original.** Si el usuario puede pedir «volver al orden original», guarda ese orden antes (una copia o un array de índices).

## Errores típicos

- **Un bloque gigante que dibuja y calcula a la vez.** Arreglo: separa modelo (datos) y vista (funciones de dibujo).
- **El scroll se pasa del final.** Arreglo: clampa `top` entre 0 y `n - alto` antes de dibujar.
- **`fopen` devuelve `NULL` y el programa muere sin avisar.** Arreglo: comprueba el puntero y sal con un mensaje.
- **Ordené con `qsort` y ya no puedo volver al orden original.** Arreglo: guarda el orden original antes de ordenar.
- **La barra de estado queda desactualizada.** Arreglo: repinta la barra en cada vuelta del bucle, junto con el contenido.

## Resumen en 5 puntos

- Modelo = datos en memoria; vista = funciones que dibujan. **El dibujo lee el modelo, nunca al revés.**
- El bucle de eventos es siempre: leer tecla → actualizar estado → repintar → `refresh`.
- Cargar un fichero: `fopen` (comprueba `NULL`), `fgets` con límite, `sscanf`, y `fclose` al final.
- La barra de estado es una fila fija que se repinta en cada cambio.
- El scroll mueve un índice `top` con clamp entre 0 y `n - alto`; `qsort` ordena in-place.

## Qué vas a practicar

- **Visor de logs:** una lista cargada de un fichero, con ventana, scroll `j`/`k` y barra de estado, como `less` o `journalctl` (`visor-de-logs`).
- **Tabla ordenable:** un inventario que se reordena por nombre, cantidad o precio con `qsort` y se repinta entero (`tabla-ordenable`).
