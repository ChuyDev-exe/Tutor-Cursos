# 6. make y portabilidad

## Objetivo

Al terminar este capítulo sabrás escribir un Makefile con reglas y dependencias, usar el tabulador que make exige, crear objetivos auxiliares y distinguir un binario ELF de Linux de un Mach-O de macOS.

## Qué es un Makefile

Un **Makefile** es un texto de órdenes para reconstruir un programa. Contiene **reglas**. Cada regla tiene un objetivo, unas dependencias y una receta:

```makefile
prog: main.o sum.o
	clang main.o sum.o -o prog
```

- `prog` es el **objetivo**: lo que make debe construir.
- `main.o sum.o` son las **dependencias**: los archivos de los que depende.
- La línea de `clang` es la **receta**: el comando que make ejecuta.

## El tabulador

Las recetas deben empezar con un **tabulador**, nunca con espacios. Con espacios, make se detiene con el error `missing separator`.

Si copias y pegas un Makefile desde otra fuente, comprueba que los tabuladores siguen ahí. La mayoría de editores pueden mostrar los caracteres invisibles para que lo veas.

## Reconstruir solo lo desactualizado

make compara fechas. Si `main.c` es más reciente que `main.o`, make recompila `main.o` y vuelve a enlazar `prog`. Si ningún archivo cambió, make no hace nada.

Por eso importan las dependencias: sin ellas, make no sabe qué hay que reconstruir.

## El objetivo por defecto

Un Makefile puede tener varias reglas. Al ejecutar `make` sin argumentos, make construye el **primer objetivo** del archivo.

Por eso el ejecutable se coloca el primero y los objetivos auxiliares al final.

## Objetivos auxiliares

Un objetivo no tiene por qué ser un archivo. Puede ser una etiqueta con una receta de utilidad:

```makefile
simbolos: suma.o
	nm suma.o | grep ' T _suma'

clean:
	rm -f prog main.o suma.o
```

- `make simbolos` ejecuta su receta y enseña el símbolo `_suma` definido en texto.
- `make clean` borra los archivos generados para empezar de cero.

## make -s

Por defecto, make imprime cada comando antes de ejecutarlo. Con `-s` lo silencia:

```bash
make -s
./prog
```

La salida queda limpia: solo se ve la del programa.

## ELF y Mach-O

El formato del binario depende del sistema. En macOS el formato es **Mach-O**; en GNU/Linux es **ELF**.

| Acción | macOS | GNU/Linux |
|---|---|---|
| Formato del binario | Mach-O | ELF |
| Compilar C | `gcc -c main.c -o main.o` | `gcc -c main.c -o main.o` |
| Ensamblar `.s` | `gcc -c hola.s -o hola.o` | `gcc -c hola.s -o hola.o` |
| Ensamblar con `as` | `as hola.s -o hola.o` | `as hola.s -o hola.o` |
| Enlazar | `clang main.o suma.o -o prog` | `gcc main.o suma.o -o prog` |
| Símbolo de `suma` | `_suma` | `suma` |
| Biblioteca matemática | ya enlazada | `-lm` al final |
| Ver símbolos | `nm prog` | `nm prog` |

Los pasos son los mismos en los dos sistemas. Cambian el formato del binario, los guiones bajos de los símbolos y la biblioteca matemática en Linux.

## Arquitecturas

Junto al formato va la **arquitectura**: x86-64 o arm64. Un ejecutable de x86-64 de GNU/Linux no corre en un Mac con chip Apple, porque cambian la arquitectura y el formato a la vez. Sin un emulador o una traducción extra, hay que compilar en el sistema de destino.

`file prog` y `uname -m` te dicen qué binario tienes y para qué máquina está hecho.

## Qué vas a practicar

- Escribir un Makefile con reglas, dependencias y recetas con tabulador.
- Ejecutar `make -s` y un objetivo auxiliar de inspección.
- Distinguir ELF de Mach-O y x86-64 de arm64.
