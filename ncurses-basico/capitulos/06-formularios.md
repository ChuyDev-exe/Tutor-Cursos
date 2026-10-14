# 6. Escribir texto: campos y formularios

## Objetivo

Al terminar este capítulo sabrás pedir líneas de texto al usuario con `wgetnstr`, apagar el eco para las contraseñas y validar lo escrito antes de usarlo.

## Mapa del capítulo

- `echo` y `noecho`: si lo que escribes se ve o no
- `wgetnstr`: leer una línea completa de una vez
- El patrón de un formulario: etiqueta, cursor, lectura
- Validar antes de pintar: nunca confíes en el usuario
- Contraseñas sin eco
- Errores típicos

## `echo` y `noecho`

`getch()` nunca imprime la tecla en pantalla; si el carácter aparece o no es cosa del **modo de eco**:

| Modo | Al escribir |
|---|---|
| `echo()` | lo que lees aparece en pantalla |
| `noecho()` | no aparece |

**Regla de oro: el eco es un modo de la pantalla, no de la función de lectura.**

## `wgetnstr`: leer una línea

`wgetnstr(win, buffer, max)` lee caracteres hasta **Enter** o hasta `max`, añade `\0` al final y devuelve `OK` o `ERR`. Bloquea hasta completar la línea.

```c
char nombre[32];
wmove(stdscr, 1, 9);                 // coloca el cursor…
wgetnstr(stdscr, nombre, 10);        // …y lee hasta 10 caracteres
```

Si la línea es más larga que `max`, se corta y el resto se descarta. **Pide un buffer de `max + 1` o mayor para el `\0`.**

## El patrón de formulario

Todo formulario grande es la misma receta, campo a campo: dibujar etiqueta, colocar el cursor, leer, validar, siguiente.

```c
echo();
mvprintw(1, 1, "Nombre:");
refresh();
wmove(stdscr, 1, 9);
wgetnstr(stdscr, nombre, 10);
// …igual con los demás campos…
```

**Regla de oro: sin `wmove` antes, el texto se escribe encima de lo anterior.**

## Validar antes de pintar

Lo que escriba el usuario es basura hasta que se demuestre lo contrario. Comprueba antes de usar el dato:

```c
int correo_ok = strchr(correo, '@') != NULL;          // ¿tiene arroba?
int digitos_ok = edad_txt[0] != '\0';                 // ¿no vacía?
for (int i = 0; edad_txt[i]; i++)
    if (!isdigit((unsigned char)edad_txt[i])) digitos_ok = 0;
long edad = strtol(edad_txt, NULL, 10);               // y en rango
```

Para limpiar un campo inválido y volver a pedirlo: `wclrtoeol(stdscr)` borra desde el cursor hasta el final de la línea; después `wmove` y `wgetnstr` otra vez.

## Contraseñas: `noecho` durante la lectura

```c
noecho();
wmove(stdscr, 3, 8);
wgetnstr(stdscr, clave, 10);
echo();          // restaura para los siguientes campos
```

Si quieres ver algo al escribir, dibuja asteriscos tú mismo; ncurses no los pone.

## Errores típicos

- **Buffer justo del tamaño de `max`:** se queda sin sitio para el `\0`. Usa `max + 1` o más.
- **No quitar el eco con la contraseña:** se ve en pantalla. Rodea la lectura con `noecho()` y `echo()`.
- **`wgetnstr` sin haber movido el cursor:** el dato se escribe encima del texto anterior. `wmove` antes de leer.
- **No validar:** cualquier basura llega a tu programa. Comprueba formato y rango siempre.
- **Olvidar `echo()` al terminar:** los siguientes campos se escriben invisibles.

## Resumen en 5 puntos

- `echo()` hace visible lo que se escribe; `noecho()` lo oculta; el `getch`/`wgetnstr` es el mismo.
- `wgetnstr(win, buffer, max)` lee hasta Enter o `max` y añade `\0`.
- Formulario = etiqueta con `mvprintw` + `wmove` + `wgetnstr` + validar.
- Valida siempre: `strchr` para `@`, `isdigit`/`strtol` para números.
- Contraseña = `noecho()` solo durante la lectura, y `echo()` después.

## Qué vas a practicar

- **Formulario de contacto:** tres campos con etiquetas y validación de correo y edad.
- **Login mascarado:** usuario visible, contraseña sin eco y comparación con `strcmp`.
