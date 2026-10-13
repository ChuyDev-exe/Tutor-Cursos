# Choque de rectángulos

Completa el programa del script. Lee dos rectángulos y comprueba si se solapan, como haría un juego para detectar un choque. Usa las funciones de SDL; no hace falta abrir ninguna ventana.

Edita solo la parte marcada con `TODO`.

## Entrada
Dos líneas. Cada una tiene cuatro enteros separados por espacios: `x y w h` (esquina de arriba a la izquierda, ancho y alto).

## Salida
- Si se solapan, dos líneas:
  ```
  choque
  interseccion: x y w h
  ```
  donde `x y w h` es el rectángulo común.
- Si no se solapan, una línea: `libre`.

Dos rectángulos que solo se tocan por el borde **no** se solapan.

## Ejemplo
Entrada:

```
20 20 60 40
50 40 60 40
```

Salida:

```
choque
interseccion: 50 40 30 20
```
