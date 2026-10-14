# Menú de inicio

Completa la función `elegir_opcion` del script. Es el menú principal de un gestor como `htop` o `ranger`: una lista de opciones y una selección que sube y baja. La función dibuja las opciones en `stdscr`, deja que el usuario se mueva y devuelve el índice de la opción elegida.

Edita solo la función marcada con `TODO`.

## Teclas

| Tecla | Efecto |
|---|---|
| `k` o flecha arriba (`KEY_UP`) | sube una opción (no pasa de la 0) |
| `j` o flecha abajo (`KEY_DOWN`) | baja una opción (no pasa de la última) |
| Enter (`'\n'`, `'\r'` o `KEY_ENTER`) o `q` | termina y devuelve la selección |
| cualquier otra | se ignora |

Si `getch()` devuelve `ERR` (se acabó la entrada) el bucle también termina.

En tu terminal funcionan las flechas de verdad. Las pruebas envían letras porque la entrada va por pipe, por eso el código acepta **letra o flecha** en el mismo `if`.

## Dibujo

- Las `n` opciones van en las filas 1 a `n` (la opción `i` en la fila `i + 1`), columna 2. La fila 0 queda libre.
- La opción seleccionada empieza en la 0 (la primera de la lista).
- La seleccionada se escribe con `"> "` delante y con `A_REVERSE` en su fila:

```c
attron(A_REVERSE);
mvprintw(fila, 2, "> %s", opciones[i]);
attroff(A_REVERSE);
```

- Las demás se escriben **sin marca**, con dos espacios delante (`"  %s"`) para que todo quede alineado.
- Borra con `erase()` antes de repintar (si no, la marca anterior queda clavada) y llama a `refresh()` al final de cada repintado.

## Entrada

Una línea con las teclas pulsadas, por ejemplo `jjk` seguido de Enter.

## Salida

El andamiaje imprime la selección y el título de la opción elegida:

```
seleccion=<indice>
titulo=<opcion elegida>
```

## Ejemplo

Entrada: `jjk` + Enter  →  Salida:

```
seleccion=1
titulo=Discos
```

Edita solo la función marcada con `TODO`.
