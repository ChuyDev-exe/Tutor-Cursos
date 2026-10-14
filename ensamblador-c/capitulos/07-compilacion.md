# 7. El proceso de compilación por dentro

## Objetivo

Al terminar este capítulo sabrás qué hace cada paso de la compilación, qué archivo produce cada uno, cómo mirar el interior de un `.o` y qué diferencia hay entre preprocesar C y preprocesar ensamblador.

## Los cuatro pasos

Cuando escribes `clang programa.c -o programa`, por dentro ocurren cuatro trabajos distintos. Puedes ejecutarlos uno a uno:

| Paso | Herramienta | Comando | Archivo que sale |
|---|---|---|---|
| 1. Preprocesado | `cpp` | `gcc -E archivo.c -o archivo.i` | `.i` (C ya sin `#include`) |
| 2. Compilación | `clang -S` | `gcc -S archivo.c -o archivo.s` | `.s` (ensamblador) |
| 3. Ensamblado | `as` | `gcc -c archivo.s -o archivo.o` | `.o` (código máquina) |
| 4. Enlace | enlazador | `clang a.o b.o -o prog` | ejecutable |

Cada paso solo lee el archivo del anterior y escribe uno nuevo. Ninguno se salta al siguiente: si el preprocesador no ha resuelto los `#define`, el compilador no puede traducir nada.

## Qué mira cada paso

- El **preprocesador** es texto a texto: sustituye `#include` por el contenido del archivo, cambia `#define` por su valor y borra los comentarios. No sabe nada de sintaxis de C.
- El **compilador** convierte C en instrucciones de máquina escritas en ensamblador. Aquí aparecen las etiquetas de función: una función `doble` se convierte en la etiqueta `_doble`.
- El **ensamblador** traduce esas instrucciones a bytes y escribe un archivo objeto. Ya no hay texto: hay código máquina y una tabla de símbolos.
- El **enlazador** junta los `.o`, les da direcciones y conecta los símbolos que faltan (capítulo 8).

Puedes comprobarlo con `-S`, que se detiene justo antes de ensamblar:

```bash
gcc -S doble.c -o doble.s
cat doble.s
```

El archivo que sale contiene `_doble:` y mnemónicos como `add w0, w0, w0`. Es exactamente el mismo formato que escribirías a mano en un `.s`.

## El preprocesador también trabaja con ensamblador

Si el archivo de ensamblador se llama `.S` con mayúscula, `gcc -c` lo pasa antes por el preprocesador. Entonces puedes usar `#define` e `#include` dentro del ensamblador:

```asm
#define OPER add

.globl _suma
_suma:
    OPER x0, x0, x1
    ret
```

Después de `gcc -E -P suma.S -o suma.i`, el archivo `suma.i` contiene `add x0, x0, x1` en lugar de `OPER x0, x0, x1`. Con `.s` en minúscula, `as` lo lee tal cual y no entiende nada de macros.

## Qué contiene un `.o`

Un archivo objeto tiene tres cosas:

1. **Secciones**: `__text` (código), `__data` (datos inicializados), `__const` (constantes), `__common` (sin inicializar).
2. **Tabla de símbolos**: los nombres que define y los que usa.
3. **Referencias sin resolver**: llamadas cuya dirección aún no se conoce.

Las direcciones dentro de un `.o` son provisionales: empiezan en cero y corresponden al principio de cada sección. Las direcciones finales las pone el enlazador.

```bash
gcc -c doble.c -o doble.o
nm doble.o
objdump -h doble.o
```

`nm` enseña `T _doble` con dirección `0000000000000000`. `objdump -h` enseña las secciones y sus tamaños. Es la foto del archivo antes de que el enlazador lo coloque en memoria.

## Un error típico de cada paso

Cada paso tiene sus propios fallos, y el mensaje te dice en cuál estabas:

- `error: 'stdio.h' file not found` → preprocesado: falta un `#include`.
- `error: expected ';'` → compilación: sintaxis de C.
- `error: unrecognized instruction mnemonic` → ensamblado: un mnemónico mal escrito.
- `Undefined symbols` o `duplicate symbol` → enlace (capítulo 5).

Si el mensaje habla de símbolos, el problema no está en el C: ya pasaste la compilación.

## Qué vas a practicar

En los ejercicios de este capítulo vas a:

1. Ejecutar los cuatro pasos a mano sobre el mismo programa y leer el archivo que produce cada uno.
2. Comprobar con `nm` que en el `.o` la dirección del símbolo sigue en cero.
3. Escribir un `.S` con macros del preprocesador y comprobar que `OPER` se sustituye antes de ensamblar.
4. Distinguir, por el mensaje de error, en qué paso se rompió el build.
