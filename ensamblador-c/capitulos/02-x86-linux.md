# 2. x86-64 y la ABI de GNU/Linux

Este capítulo es solo teoría. Estudia la arquitectura x86-64 y el sistema GNU/Linux, tal como se ve en muchos manuales y cursos. Los ejercicios prácticos de este curso se ejecutan en macOS con chip arm64, así que aquí no vas a escribir código que corra. Vas a aprender a leer y reconocer el otro mundo.

## Registros principales

x86-64 es una arquitectura de 64 bits con registros de nombres distintos a los de ARM64. Los más importantes son:

- `rax`: valor de retorno de una función.
- `rdi`: primer argumento entero de una función.
- `rsi`: segundo argumento entero.
- `rsp`: puntero de pila.
- `rbp`: puntero de la base del marco de pila (frame pointer).

Hay más (`rdx`, `rcx`, `r8`, `r9`), pero con estos cinco lees casi todo el código de ejemplo de este capítulo.

## La pila crece hacia abajo

La pila es una región de memoria que el programa usa para guardar direcciones de retorno y datos locales. En x86-64 la pila crece hacia direcciones más bajas: empieza alta y baja con cada `push`. El registro `rsp` apunta siempre a la cima actual de la pila. Al hacer `pop`, `rsp` vuelve a subir. En ARM64 la pila también crece hacia abajo; solo cambia el nombre del registro, que es `sp`.

## `call` y `ret`

Dos instrucciones controlan las llamadas en x86-64:

- `call nombre` guarda la dirección de retorno en la pila y salta a `nombre`.
- `ret` saca esa dirección de la pila y salta a ella, es decir, vuelve al punto de la llamada.

Por eso la pila debe estar equilibrada al volver: lo que se apiló se desapila.

## La ABI System V AMD64

La ABI (interfaz binaria de aplicación) es el conjunto de reglas que acuerdan funciones de distinto origen para llamarse entre sí. La de GNU/Linux en x86-64 se llama System V AMD64 ABI, a menudo abreviada SysV. Sus reglas de llamada:

- Los primeros seis argumentos enteros van en `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`, en ese orden.
- El valor de retorno se devuelve en `rax`.
- El resto de argumentos, si los hay, van por la pila.

En ARM64 de Apple la idea es parecida, pero los registros son `x0`–`x7` para argumentos y `x0` para retorno.

## Sintaxis AT&T

En GNU/Linux el ensamblador por defecto usa la sintaxis AT&T. Tiene dos diferencias con la sintaxis que verás en macOS:

1. Cada registro lleva `%` delante: `%rax`, `%rdi`.
2. El orden es origen, destino. La instrucción `movq %rdi, %rax` copia `rdi` en `rax`.

En la sintaxis Intel sería al revés: destino primero. Si lees código de internet, comprueba siempre de qué sintaxis se trata.

## Formato ELF

Los binarios de GNU/Linux usan el formato ELF. En un archivo ELF los símbolos de funciones aparecen sin guion bajo: `suma`, no `_suma`. Esa diferencia de nombres respecto a Mach-O es la más visible al usar `nm` en los dos sistemas.

## Comandos de Linux

Con las herramientas de GNU el pipeline es este:

```bash
as suma.s -o suma.o
ld suma.o -o suma
gcc suma.s -o suma
```

`as` ensambla a `.o`. `ld` es el enlazador y produce el ejecutable. `gcc suma.s -o suma` hace ambas cosas de una sola vez. Para inspeccionar archivos usas `readelf` (equivalente a las utilidades de binarios de ELF) y `objdump`, que desensambla igual que en macOS.

## Qué vas a practicar

En este capítulo no hay ejercicios de escritura. Lo que vas a practicar en la evaluación es reconocer:

1. Los registros `rax`, `rdi`, `rsi`, `rsp` y `rbp` y para qué sirve cada uno.
2. El orden de argumentos de la ABI System V AMD64.
3. La sintaxis AT&T: `%` delante de registros y orden origen, destino.
4. La diferencia entre ELF y Mach-O, y entre los comandos de Linux (`as`, `ld`, `gcc`, `readelf`, `objdump`) y los de macOS (`as`, `clang`, `nm`, `objdump`).
