# 12. Nombres de símbolos y reglas de nombrado

## Objetivo

Al terminar este capítulo sabrás cómo nombra el sistema cada función y variable, por qué en macOS aparecen con guion bajo, qué distingue a un símbolo global de uno local y qué letras usa `nm` para clasificarlos.

## El guion bajo de Mach-O

Cuando C genera el símbolo de una función, Mach-O le añade un guion bajo por delante. La función `suma` se guarda como `_suma`. En Linux (ELF) no: allí el símbolo es `suma`.

Por eso en este curso toda etiqueta de ensamblador que C va a llamar lleva guion bajo:

```asm
.globl _suma      @ C llama a suma
.globl _main      @ C llama a main
```

Y también al revés: si ensamblas a mano un `.s` que llama a `printf`, la etiqueta es `_printf`. El guion bajo no es decoración: es parte del nombre que enlazador busca en la tabla de símbolos.

## Global, local y estático

Tres niveles distintos:

| Quién lo escribe | En el `.o` | Visible para otros archivos |
|---|---|---|
| `.globl _funcion` | `T _funcion` | sí |
| etiqueta sin `.globl` | `t _funcion` | no |
| `static int x;` en C | `d x` / `b x` | no |

- La letra **mayúscula** (`T`, `D`, `C`) dice que el símbolo es global: otros `.o` pueden verlo.
- La letra **minúscula** (`t`, `d`, `b`) dice que es local: existe en este archivo y en ningún otro.

Los locales no llegan al ejecutable: el enlazador los resuelve dentro de su archivo y luego los tira. Por eso `nm pieza.o` enseña `_interna` y `nm prog` ya no.

En C, `static` aplicado a una función o variable de fichero hace exactamente lo mismo que una etiqueta sin `.globl`: cada archivo puede tener su propia versión sin que haya conflicto.

## Reglas de nombrado

- Un símbolo global debe estar **definido una sola vez** en todo el enlace. Dos definiciones → `duplicate symbol`.
- Un símbolo usado debe estar **definido en algún sitio**. Ninguna definición → `Undefined symbols`.
- Los nombres con `static` no cuentan para esas reglas: cada archivo tiene los suyos.
- En C, los identificadores que empiezan por guion bajo seguido de mayúscula (`_Printf`) están reservados por la norma; el sistema los usa para sus propios símbolos.
- En C++, el compilador altera los nombres para codificar los tipos (*name mangling*): `suma(int)` no se llama `suma` sino algo como `_Z4sumai`. Por eso hay que declarar `extern "C"` cuando se llama a una función escrita en C o en ensamblador.
- Las macros y los `#define` no son símbolos: no aparecen en `nm` porque desaparecen en el preprocesado.

## Las letras de nm

Completas, para Mach-O:

| Letra | Significado |
|---|---|
| `T` / `t` | código en `__text`, global / local |
| `D` / `d` | dato inicializado, global / local |
| `B` / `b` | dato sin inicializar, global / local |
| `C` | definición tentativa (common) en un `.o` |
| `S` / `s` | otra sección (`__const`, `__cstring`, `__common`) |
| `U` | usado aquí, definido en otro sitio |

En ELF los nombres de sección son los habituales (`.text`, `.data`, `.bss`), así que aparecen `T`, `D` y `B`.

## Diagnosticar con nm

La lectura rápida de una tabla de símbolos es siempre la misma:

1. ¿Aparece lo que busco con mayúscula? → está definido ahí.
2. ¿Aparece con `U`? → falta definirlo en otro archivo.
3. ¿Aparece dos veces con mayúscula en dos archivos? → `duplicate symbol`.
4. ¿No aparece? → o es local (`static`), o no existe, o el compilador lo eliminó por no usarse.

## Qué vas a practicar

En los ejercicios de este capítulo vas a:

1. Escribir una etiqueta global y otra local en el mismo `.s` y leer la diferencia en `nm`.
2. Comprobar que la local desaparece al enlazar.
3. Provocar un `duplicate symbol` con dos funciones globales iguales.
4. Comprobar que dos funciones `static` iguales en ficheros distintos sí enlazan, y que quitar el guion bajo provoca `Undefined symbols`.
