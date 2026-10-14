# 10. Linker scripts: mandar en la memoria

## Objetivo

Al terminar este capítulo sabrás qué es un linker script, qué mandato tiene sobre la colocación de las secciones, cómo se declara un mapa de memoria con `MEMORY` y qué significan los comodines y `/DISCARD/`.

## Qué es un linker script

Por defecto, el enlazador usa un guion interno que decide dónde va cada sección. Cuando ese guion no basta, se lo escribes tú: ese archivo es el **linker script**.

Se usa sobre todo en sistemas embebidos, donde no hay sistema operativo que cargue el programa: el enlazador es el que decide qué queda en la flash y qué queda en la RAM. Pero también sirve para colocar una rutina de arranque en una dirección concreta, separar secciones por tamaño o tirar a la basura lo que no hace falta.

El formato más extendido es el de GNU ld:

```bash
ld -T memoria.ld a.o b.o -o prog
```

## Anatomía de un `SECTIONS`

El bloque `SECTIONS` es una lista de «esta sección va aquí»:

```ld
SECTIONS
{
  . = 0x08000000;
  .text : { *(.text) }
  .rodata : { *(.rodata*) }
  .data : { *(.data) }
}
```

Trozo a trozo:

- `. = 0x08000000;` mueve el contador de ubicación: la siguiente sección empieza en esa dirección.
- `.text : { ... }` declara una sección de salida llamada `.text`.
- `*(.text)` es un comodín: dentro van las `.text` de **todos** los objetos de entrada. Un solo `*` significa «todos los archivos».
- `*(.rodata*)` significa «todas las secciones que empiezan por `.rodata`», porque el compilador genera variantes como `.rodata.str1.1`.

La llave que cierra cada sección y la que cierra el bloque deben contar. Un script con las llaves desequilibradas no se puede leer.

## Descartar con `/DISCARD/`

```ld
/DISCARD/ : { *(.comment) }
```

`/DISCARD/` es una sección de salida especial: lo que entre en ella no se escribe en el resultado. Es la forma de tirar las notas de versión del compilador, los atributos o las secciones de depuración.

También se puede proteger algo que el enlazador podría descartar si nadie lo referencia:

```ld
.text : { KEEP(*(.vectors)) *(.text) }
```

`KEEP` dice «esto no se descarta aunque parezca muerto», que es lo que necesitas con las tablas de interrupciones y con el código de arranque.

## El mapa de memoria con `MEMORY`

Si el programa tiene varios bloques de memoria distintos (flash y RAM, por ejemplo), se declaran primero y luego se dice qué sección va a cada uno:

```ld
MEMORY
{
  FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 64K
  RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 16K
}

SECTIONS
{
  .text : { *(.text) }   > FLASH
  .data : { *(.data) }   > RAM AT > FLASH
  .bss  : { *(.bss) }    > RAM
}
```

- `ORIGIN` es la dirección de arranque del bloque.
- `LENGTH` es su tamaño (acepta sufijos `K` y `M`).
- `> FLASH` coloca la sección en ese bloque.
- `AT > FLASH` dice dónde se **carga** la sección aunque se **ejecute** en otro sitio: es la base de la diferencia entre VMA y LMA del capítulo siguiente.

Si una sección no cabe en el bloque indicado, el enlazador se niega a enlazar en lugar de escribir un ejecutable roto.

## Nota de plataforma

Los linker scripts con esta sintaxis pertenecen a GNU ld (GNU/Linux, embebidos). El `ld` de macOS (`ld64`) no los admite: usa opciones como `-segaddr`, `-dead_strip` y `-map`, y el mapa de memoria lo fija el sistema.

Por eso los ejercicios de este capítulo te piden **escribir el script con su sintaxis** y lo comprueban con un validador: el objetivo es que domines el formato, que es el que usarás en cualquier trabajo embebido o en GNU/Linux.

## Qué vas a practicar

En los ejercicios de este capítulo vas a:

1. Escribir un `SECTIONS` completo: asignación de dirección, `.text`, `.rodata` y comodines.
2. Declarar un mapa `MEMORY` con `ORIGIN` y `LENGTH` y colocar `.text`, `.data` y `.bss` en su bloque.
3. Equilibrar llaves y respetar la sintaxis hasta que el validador dé `script: valido`.
4. Usar `/DISCARD/` para tirar secciones que no quieres en el resultado.
