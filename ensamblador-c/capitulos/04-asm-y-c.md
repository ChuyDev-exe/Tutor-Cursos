# 4. Agregar ensamblador a C

## Objetivo

En este capítulo vas a mezclar C y ensamblador. Vas a llamar a una función escrita en ensamblador desde un programa en C, de dos formas: con ensamblador en línea dentro del propio `.c` y con un archivo `.s` aparte.

## La regla del guion bajo

En Mach-O, el formato de binarios de macOS, los símbolos de funciones llevan un guion bajo. La función C `suma` se llama `_suma` en el archivo ensamblador. En Linux (ELF) sería `suma`, sin guion. Esta es la diferencia más visible entre los dos sistemas.

## El prototipo en C y la definición en ensamblador

C solo necesita el prototipo, que declara el nombre y los tipos:

```c
int suma(int, int);
```

La definición vive en el archivo `.s`:

```asm
.globl _suma
_suma:
    add x0, x0, x1
    ret
```

`.globl _suma` hace el símbolo visible para otros archivos. Los argumentos llegan en `x0` y `x1`, y el resultado se devuelve en `x0`. Esta parte de la ABI sí usa registros: la excepción son las funciones variadicas como `printf` y `scanf`, que llevan sus argumentos extra por la pila.

## Compilar por separado y enlazar

Cada archivo se compila a su propio archivo objeto con `gcc -c`:

```bash
gcc -c suma.s -o suma.o
gcc -c main.c -o main.o
clang main.o suma.o -o prog
```

`gcc -c` detiene el proceso después de generar el `.o`; el resultado todavía no es un programa. El paso de enlace lo hace `clang`, que junta los dos `.o` y añade las bibliotecas del sistema.

## Leer los símbolos con nm

`nm` enseña la tabla de símbolos de un `.o`. Cada línea tiene una dirección, una letra y el nombre. Las dos letras que vas a usar son:

- `T`: el símbolo está definido en este archivo, en la sección de texto.
- `U`: el símbolo se usa aquí pero se define en otro sitio.

```bash
$ nm suma.o
0000000000000000 T _suma
```

Si el `.s` llamara a `printf`, aparecería también `U _printf`. El enlazador será el que encuentre esa función en la biblioteca del sistema.

## Ensamblador en línea con __asm__

También puedes escribir ensamblador dentro de un `.c` con `__asm__ volatile`:

```c
int suma(int a, int b) {
  int r;
  __asm__ volatile("add %w0, %w1, %w2" : "=r"(r) : "r"(a), "r"(b));
  return r;
}
```

La plantilla tiene tres zonas separadas por dos puntos:

1. El texto de la instrucción, entre comillas.
2. Los operandos de salida: `"=r"(r)` significa «escribe el resultado en una variable que el compilador elija».
3. Los operandos de entrada: `"r"(a)` y `"r"(b)` son los valores de `a` y `b`.

`%w0`, `%w1` y `%w2` son las vistas de 32 bits de los tres operandos, en el mismo orden. Si la instrucción modifica registros que no aparecen en los operandos, se declaran en una cuarta zona llamada clobbers.

## Quién lee la entrada

La regla de este curso: el `main` en C lee la entrada con `scanf` y el ensamblador solo calcula. Así el ensamblador se queda corto y el foco del ejercicio está en la ABI y en las instrucciones.

## El ensamblador también puede llamar a C

El camino inverso también funciona. Un `.s` puede llamar a `printf` o a cualquier función de C con `bl _printf`, cargando el formato en `x0` y los argumentos extra en la pila. Son las mismas reglas que en el capítulo anterior: los dos mundos comparten la misma ABI.

## Qué vas a practicar

En los ejercicios de este capítulo vas a:

1. Completar una instrucción `add` escrita en ensamblador dentro de C.
2. Declarar el guion bajo `_suma` en un archivo `.s`.
3. Compilar dos archivos por separado con `gcc -c` y enlazarlos con `clang`.
4. Ejecutar un programa donde C lee la entrada y el ensamblador solo calcula.
