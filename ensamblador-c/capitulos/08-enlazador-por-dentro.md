# 8. El enlazador por dentro: secciones y direcciones

## Objetivo

Al terminar este capítulo sabrás cómo fusiona el enlazador las secciones de varios archivos objeto, cómo pasa de direcciones provisionales a direcciones reales y dónde mirar para ver qué ha colocado en memoria y en qué sitio.

## Fusionar secciones

Cada `.o` llega con sus propias secciones. El enlazador no las pone unas al lado de otras: **las fusiona por nombre**. Todo lo que hay en `__text` de todos los `.o` acaba en un único `__text` del ejecutable, y lo mismo con `__data`, `__const` y el resto.

```bash
as fa.s -o fa.o
as fb.s -o fb.o
objdump -h fa.o fb.o
```

Cada objeto enseña un `__text` con su tamaño. Después de enlazar:

```bash
clang fa.o fb.o -o prog
objdump -h prog
```

Hay un solo `__text`, con un tamaño igual a la suma de los dos. Las etiquetas `_fa` y `_fb` siguen ahí, cada una con su dirección dentro de esa sección común.

Existe una orden intermedia, `ld -r`, que fusiona objetos sin producir un ejecutable:

```bash
ld -r fa.o fb.o -o todo.o
```

El resultado es un `.o` nuevo, con una sola sección `__text` y las dos funciones. Útil para mirar el interior de la fusión sin añadir aún las bibliotecas del sistema. Si los dos objetos definen el mismo símbolo, `ld -r` ya se queja con `duplicate symbol`.

## De direcciones provisionales a direcciones reales

Dentro de un `.o` las direcciones son cero al principio de cada sección: son relativas. El enlazador hace tres cosas con ellas:

1. Elige la dirección de cada sección dentro del ejecutable.
2. Suma a cada símbolo el desplazamiento de su sección y el de su archivo.
3. Sustituye cada referencia sin resolver por ese número final.

Por eso el mismo símbolo cambia de aspecto según dónde lo mires:

```bash
gcc -c main.c -o main.o     # aquí: U _doble (sin resolver)
nm main.o | grep _doble

clang main.o doble.o -o prog
nm prog | grep _doble       # aquí: T _doble con dirección de 16 cifras
```

Una `U` en el `.o` se convierte en una `T` con dirección real en el ejecutable. Ese es exactamente el trabajo del enlazador.

## Asignación en memoria

El ejecutable no es un bloque homogéneo: el enlazador reparte el código y los datos en **segmentos**. En Mach-O los dos importantes son:

- `__TEXT`: código y constantes de solo lectura.
- `__DATA`: variables que el programa puede escribir.

`objdump -h prog` muestra cada sección con su dirección (VMA), su tamaño y su tipo. `nm -m` enseña algo todavía más claro: la sección exacta donde vive cada símbolo.

```bash
nm -m prog | grep _contador
# 0000000100008000 (__DATA,__data) external _contador
```

## El mapa de enlace

Cuando quieres ver el reparto completo, pide un mapa de enlace con `-map`:

```bash
clang main.o doble.o -o prog -Wl,-map,prog.map
cat prog.map
```

El mapa tiene tres bloques:

- **Object files**: qué archivos ha metido el enlazador (y de dónde salió cada uno).
- **Sections**: dirección, tamaño, segmento y sección de cada trozo.
- **Symbols**: dirección final de cada símbolo y qué archivo lo aportó.

Es el documento de referencia cuando algo queda en una dirección que no esperabas.

## Una trampa: el desplazamiento del sistema

Las direcciones que enseña `nm` son las del archivo. Al cargar el programa, macOS mueve todo el bloque (ASLR), así que la dirección real en tiempo de ejecución es la del `nm` más un desplazamiento que cambia en cada ejecución. Las relaciones se conservan: si en el `nm` `_b` está 16 bytes por delante de `_a`, en ejecución también.

Por eso se compara `printf("%p", &x)` con otro `%p` de la misma ejecución, y no con el valor del `nm`.

## Qué vas a practicar

En los ejercicios de este capítulo vas a:

1. Fusionar dos `.o` con `ld -r` y comprobar que dos secciones `__text` pasan a ser una.
2. Provocar un `duplicate symbol` justo en el momento de fusionar.
3. Seguir a un símbolo desde su `U` en el `.o` hasta su `T` en el ejecutable.
4. Leer el mapa de enlace y localizar el segmento y la sección del código.
