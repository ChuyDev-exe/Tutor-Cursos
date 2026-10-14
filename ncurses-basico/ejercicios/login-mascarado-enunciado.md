# Login mascarado

Completa la función `verificar_login` del script. El andamiaje ya ha pedido el usuario; a ti te toca pedir la contraseña **sin que se vea en pantalla** y comprobar las credenciales: usuario `admin`, clave `s3cret`.

Edita solo la función marcada con `TODO`.

## Qué debe hacer `verificar_login`

1. Apagar el eco con `noecho()`, dibujar `Clave:` en (3, 1), colocar el cursor en (3, 8) con `wmove` y leer la clave con `wgetnstr(stdscr, clave, 10)` en un `char clave[11]` local.
2. Volver a encender el eco con `echo()` justo después de leer.
3. Comparar con `strcmp`: usuario igual a `"admin"` **y** clave igual a `"s3cret"`.
4. Dibujar el resultado en (5, 1): `Acceso concedido` o `Acceso denegado`; después `refresh()`.
5. Devolver 1 si todo coincide, 0 si no.

## Entrada
Dos líneas: usuario y clave (con Enter al final de cada una).

## Salida
Una línea con el usuario leído, la clave siempre oculta y el resultado:

```
usuario=<usuario> clave=*** acceso=<concedido|denegado>
```

## Ejemplo
Entrada: `admin\ns3cret`  →  Salida:

```
usuario=admin clave=*** acceso=concedido
```
