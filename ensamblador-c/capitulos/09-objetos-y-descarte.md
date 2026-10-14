# 9. Varios objetos y el enlazador travieso

## Objetivo

Al terminar este capítulo sabrás qué decide el enlazador cuando le pasas varios archivos, cómo arrastra piezas sin que tú se lo pidas, cómo obligarlo a cargar algo a la fuerza y cómo descartar código que nadie usa.

## Enlazar varios objetos

La orden de enlace puede llevar tantos `.o` como quieras:

```bash
clang main.o fa.o fb.o -o prog
```

Las reglas son las de siempre y conviene repetirlas:

- Cada símbolo usado debe tener **una y solo una** definición en el conjunto.
- Dos definiciones del mismo símbolo → `duplicate symbol`.
- Ninguna definición → `Undefined symbols`.
- El orden importa cuando hay bibliotecas: una biblioteca satisface las referencias que ya se han visto, no las futuras.

`ld -r a.o b.o -o todo.o` hace la comprobación de duplicados en el momento de fusionar, antes incluso de buscar bibliotecas del sistema.

## El enlazador travieso

El enlazador hace cosas que no le has pedido explícitamente. Las más habituales:

1. **Arrastra miembros de biblioteca en silencio.** Si `libayuda.a` contiene `ayuda.o` y tu código usa `helper`, el enlazador mete `ayuda.o` sin avisar. Si nadie usa nada de esa biblioteca, no mete nada.
2. **Añade piezas del sistema**: el arranque (`_main` del runtime), el soporte de `printf`, las estructuras de excepción.
3. **Resuelve símbolos en un orden que no es el de la línea de comandos**, buscando en las bibliotecas hasta que todo queda cubierto.

Puedes verlo en acción con `-t`, que registra cada archivo que el enlazador carga:

```bash
clang main.o -L. -layuda -o prog -Wl,-t 2>&1 | head
```

Y puedes darle una orden que no ha pedido: `-u` marca un símbolo como «necesario aunque nadie lo llame», lo que fuerza la carga del miembro de la biblioteca que lo define:

```bash
clang main.o -L. -layuda -Wl,-u,_helper -o prog
```

Sin `-u` y sin una llamada a `helper`, el símbolo no aparece en el ejecutable. Con `-u`, aparece. El enlazador obedece, pero solo si se lo dices.

## Descartar secciones del mismo archivo

Un archivo puede contener código que nadie llama. El enlazador tiene una opción para eliminarlo: `-dead_strip`.

```bash
clang main.o piezas.o -Wl,-dead_strip -o prog
```

El símbolo `_hueca` desaparece de `nm` si nadie lo referencia, y **puede desaparecer aunque esté en el mismo archivo que una función que sí se usa**. Para eso hace falta una directiva en el propio `.s`:

```asm
.subsections_via_symbols
```

Sin esa línea, todo el `__text` de ese archivo es un único bloque indivisible: si una parte se usa, se queda entero. Con la línea, cada función es una subsección que puede descartarse por separado.

Para ver qué ha descartado, usa `-Wl,-why_live,_hueca`: si el enlazador imprime `dont-dead-strip`, la pieza se ha quedado; si no imprime nada, estaba muerta.

## Descartar y comodines

En los linker scripts de GNU se descarta por patrones, con comodines que significan «todos los archivos» y «todas las secciones que empiecen así»:

```ld
/DISCARD/ : { *(.comment) }
.text : { *(.text) }
.rodata : { *(.rodata*) }
```

- `*(.text)` → la sección `.text` de **todos** los objetos.
- `*(.rodata*)` → `.rodata` y cualquier variante (`.rodata.str1.1`, `.rodata.cst4`…).
- `/DISCARD/` → sección de destino que no se escribe en el resultado.

En macOS, el equivalente práctico es `strip`: quita del ejecutable las secciones de depuración y los símbolos locales.

```bash
clang -g datos.c -o prog
objdump -h prog        # ahí está lo de depuración en los .o
strip -S prog
```

## Qué vas a practicar

En los ejercicios de este capítulo vas a:

1. Enlazar dos objetos y listar los símbolos con y sin `-dead_strip`.
2. Descartar una función del mismo archivo que otra que sí se usa.
3. Comprobar que un miembro de biblioteca no se arrastra si nadie lo referencia.
4. Forzar esa carga con `-Wl,-u,_helper` y ver aparecer el símbolo.
