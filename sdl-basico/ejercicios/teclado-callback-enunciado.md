# Control de teclado con callbacks

Completa el programa para mover un rectángulo con las flechas del teclado usando una función callback. Cuando se presione una flecha, el rectángulo se moverá 5 píxeles en esa dirección.

Edita solo la función `manejar_tecla` marcada con `TODO`.

## Qué debe hacer `manejar_tecla`

1. Si `tecla == SDLK_LEFT`, mover el rectángulo a la izquierda restando 5 a `x`.
2. Si `tecla == SDLK_RIGHT`, mover el rectángulo a la derecha sumando 5 a `x`.
3. Si `tecla == SDLK_UP`, mover el rectángulo hacia arriba restando 5 a `y`.
4. Si `tecla == SDLK_DOWN`, mover el rectángulo hacia abajo sumando 5 a `y`.
5. Asegúrate de que el rectángulo no se salga de los bordes de la ventana (800x600).

## Datos iniciales (ya puestos en el andamiaje)

- El rectángulo empieza en `x = 400, y = 500` (cercano al borde inferior).
- El rectángulo mide `w = 50, h = 30`.
- Los límites: `x` debe estar entre 0 y `ANCHO - w`, `y` entre 0 y `ALTO - h`.

## Entrada

Presiona las flechas izquierda, derecha, arriba, abajo.

## Salida

El rectángulo se moverá 5 píxeles por presión de tecla, manteniéndose dentro de la ventana. Después de 3 segundos o al cerrar la ventana, el programa termina.

## Ejemplo

Presiona `SDLK_UP` una vez → el rectángulo se mueve 5 píxeles hacia arriba (y disminuye su valor).