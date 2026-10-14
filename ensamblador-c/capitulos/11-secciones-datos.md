# 11. .rodata, .data y .bss: VMA, LMA y un solo banco

## Objetivo

Al terminar este capítulo sabrás dónde viven las constantes, las variables inicializadas y las que no, quién pone a cero la `.bss` y qué significa que una sección tenga dos direcciones distintas: la de ejecución (VMA) y la de carga (LMA).

## .rodata: lo que no cambia

Las constantes no van en el código pero tampoco se escriben nunca. Van a `.rodata` (de *read-only data*):

```c
const char mensaje[] = "hola";
const int tabla[3] = {1, 2, 3};
```

Las cadenas sueltas del código (`printf("hola")`) también acaban ahí. En macOS, Mach-O las reparte entre `__TEXT,__const` (arreglos `const`) y `__TEXT,__cstring` (cadenas literales): ambas quedan en el segmento de solo lectura, que el sistema se niega a escribir.

## .data: lo inicializado

Las variables con un valor escrito en el fuente van a `.data`:

```c
int contador = 42;
```

Ese `42` tiene que estar escrito en el archivo del programa: alguien tiene que ponerlo en memoria antes de que la variable se use. Por eso `.data` ocupa sitio tanto en el archivo como en la RAM.

## .bss: lo que basta con poner a cero

Las variables declaradas sin inicializar no necesitan ocupar sitio en el archivo:

```c
int contador;          // en .bss
unsigned char buffer[1024];
```

El sistema sabe que basta con que estén a cero. El enlazador reserva el hueco en memoria pero no escribe bytes en el archivo: esa sección es `.bss`. Por eso un buffer de un megabyte sin inicializar no aumenta el tamaño del ejecutable.

En Mach-O verás este caso de dos formas: en el `.o` como símbolo `C` (*common*) y en el ejecutable dentro de `__DATA,__common`, que `objdump -h` marca como tipo `BSS`.

## ¿Quién pone a cero la .bss?

En un sistema operativo, el arranque del sistema y la biblioteca C lo hacen por ti. En un sistema embebido, **lo haces tú**, en la rutina de arranque, antes de llamar a `main`:

```asm
    ldr x0, =_sbss
    ldr x1, =_ebss
1:  cmp x0, x1
    b.hs 2f
    strb wzr, [x0], #1
    b 1b
2:
```

`_sbss` y `_ebss` son símbolos que define el linker script al principio y al final de la sección:

```ld
_sbss = .;
.bss : { *(.bss) }
_ebss = .;
```

Si olvidas ese bucle, tus variables globales arrancan con la basura que había en la RAM: el clásico fallo que solo aparece en el hardware.

El mismo problema tiene `.data`: sus valores están escritos en la flash, pero se leen desde la RAM.

## Problemas de un solo banco de memoria

En muchos microcontroladores hay un único banco que se puede leer y ejecutar. Si `.data` y `.bss` tienen que vivir en RAM pero la RAM empieza vacía, hay dos trabajos de arranque:

1. **Copiar `.data`** desde su origen (flash) hasta su destino (RAM).
2. **Poner a cero `.bss`**.

Para poder hacer el primero, la sección necesita dos direcciones distintas.

## VMA y LMA

- **VMA** (*Virtual Memory Address*): la dirección en la que la sección se **ejecuta** y se usa.
- **LMA** (*Load Memory Address*): la dirección desde la que la sección se **carga** al arrancar el equipo.

Para `.text`, `.rodata` y `.bss` las dos coinciden (en la flash o en la RAM, según donde estén). Para `.data` no:

```ld
.data : { *(.data) } > RAM AT > FLASH
```

Significa: «se ejecuta en RAM, se carga desde la flash». El arranque copia cada byte desde la LMA hasta la VMA. Con un banco solo, esa copia es obligatoria.

El ejemplo completo con números:

| Sección | VMA (RAM) | LMA (flash) | Quién la llena |
|---|---|---|---|
| `.text` | 0x20000000 | 0x08000000 | el cargador |
| `.data` | 0x20001000 | 0x08008000 | el arranque la copia |
| `.bss`  | 0x20002000 | 0x20002000 | el arranque la pone a cero |

Si te fijas, la LMA de `.data` suele calcularse al final de la flash: `ORIGIN + LENGTH - tamaño(.data)`, para que no se solape con el código.

## Qué vas a practicar

En los ejercicios de este capítulo vas a:

1. Localizar con `nm -m` y `objdump -h` dónde vive cada tipo de dato.
2. Distinguir en un ejecutable real `__TEXT,__const`, `__DATA,__data` y `__DATA,__common`.
3. Escribir en ensamblador una rutina que pone a cero un rango de memoria, como el bucle de arranque de la `.bss`.
4. Comprobar que el hueco de `.bss` no ocupa sitio en el archivo pero sí en memoria.
