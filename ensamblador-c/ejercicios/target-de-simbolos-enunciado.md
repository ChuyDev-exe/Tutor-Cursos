# Target de simbolos

El Makefile de este script es igual que el del ejercicio anterior, pero añade un objetivo auxiliar llamado `simbolos`. Un objetivo no tiene por qué ser un archivo: puede ser una etiqueta con una receta de utilidad.

La receta de `simbolos` debe mostrar el símbolo `_suma` definido en el texto de `suma.o`. El resto del Makefile y los ficheros C ya están completos.

## Entrada

Una línea con dos números enteros, separados por un espacio. El script la usa al ejecutar `./prog`.

## Salida

Lo que imprima `./prog` y, al final, una línea de `nm` que contiene `T _suma`. Las pruebas comprueban que aparece `T _suma`.

## Ejemplo

Con la entrada `3 4`, el script imprime `r=7` y después una línea como `0000000000000000 T _suma`.
