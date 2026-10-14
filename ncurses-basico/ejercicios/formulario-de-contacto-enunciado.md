# Formulario de contacto

Completa la función `pedir_contacto` del script. Dibuja un formulario de tres campos (nombre, correo y edad), lee lo que escriba el usuario y lo valida. Es el esquema de cualquier formulario de registro.

Edita solo la función marcada con `TODO`.

## Qué debe hacer `pedir_contacto`

1. Activar `echo()` y dibujar las etiquetas: `Nombre:` en (1, 1), `Correo:` en (3, 1), `Edad:` en (5, 1); después `refresh()`.
2. Colocar el cursor con `wmove` y leer cada campo con `wgetnstr`:
   - nombre en (1, 9), hasta 10 caracteres;
   - correo en (3, 9), hasta 20 caracteres;
   - edad en (5, 8), hasta 3 caracteres, en un `char edad_txt[4]` local.
3. Validar el correo: debe contener `@` (`strchr`).
4. Validar la edad: no vacía, solo dígitos (`isdigit` en bucle) y convertida con `strtol` debe valer entre 1 y 149. Si no son dígitos, `*edad` se queda en 0; si son dígitos, guarda el número leído aunque el correo esté mal.
5. `*valido` a 1 solo si el correo tiene `@` **y** la edad es un número entre 1 y 149; a 0 en caso contrario.

## Entrada
Tres líneas: nombre, correo y edad (con Enter al final de cada una).

## Salida
Una línea con los tres campos y el resultado de la validación:

```
nombre=<nombre> correo=<correo> edad=<edad> valido=<si|no>
```

## Ejemplo
Entrada: `Ana\nana@mail.com\n30`  →  Salida:

```
nombre=Ana correo=ana@mail.com edad=30 valido=si
```
