# Manual de configuración

## Requisitos

| Herramienta | Versión mínima | Para qué |
|---|---|---|
| GCC o Clang (`gcc`) | 9 | Compilar los programas en C |
| Biblioteca ncurses (con sus cabeceras) | 5 | Dibujar en la terminal (`#include <ncurses.h>`, `-lncurses`) |
| `bash` | 3.2 | Ejecutar los scripts de los ejercicios |

ncurses no tiene un comando propio para comprobar su versión. El script de setup comprueba que se puede compilar un programa con `-lncurses`.

## Instalación

- **macOS:** ejecuta `xcode-select --install`. ncurses ya viene con las herramientas de desarrollador.
- **Linux (Debian/Ubuntu):** `sudo apt install build-essential libncurses-dev`.
- **Linux (Fedora):** `sudo dnf install gcc ncurses-devel`.
- **Windows:** instala WSL con `wsl --install` y sigue los pasos de Linux dentro de WSL.

## Preparar el entorno

1. Abre una carpeta cualquiera como workspace del editor.
2. Ejecuta **Tutor: Verificar requisitos del curso**.
3. Ejecuta **Tutor: Ejecutar setup del curso**. Debe terminar con «Listo».
4. Abre el capítulo 1 y lee su manual.
5. Cada ejercicio es un archivo `.sh`. Edita solo la función marcada con `TODO`.

## El curso

De lo básico a lo avanzado, 10 capítulos y 20 ejercicios con aplicación real:

| # | Capítulo | Ejercicios |
|---|---|---|
| 1 | Tu primera interfaz de texto con ncurses | Saludo en ventana, mover con teclas |
| 2 | El teclado: de una tecla a las flechas | Menú de inicio, calculadora de teclas |
| 3 | Colores y atributos | Panel de estados, termómetro de uso |
| 4 | Ventanas, subventanas y marcos | Panel de logs, tabla con bordes |
| 5 | Pads: contenido más grande que la pantalla | Visor de informe, tabla ancha |
| 6 | Escribir texto: campos y formularios | Formulario de contacto, login mascarado |
| 7 | Tiempo, animación y refresco | Barra de progreso, cuenta atrás |
| 8 | Geometría, tamaño y layouts | Caja centrada, rejilla de apps |
| 9 | Aplicaciones reales: datos, scroll y estado | Visor de logs, tabla ordenable |
| 10 | Proyectos: de la librería al juego | Serpiente, Juego de la Vida |

## Problemas comunes

- **«ncurses.h: No such file or directory»:** faltan las cabeceras. En Linux instala `libncurses-dev` (o `ncurses-devel`).
- **«undefined reference to `initscr`» o «Undefined symbols»:** falta `-lncurses` en la línea de `gcc`.
- **La terminal quedó rara después de un programa:** el programa terminó sin `endwin()`. Escribe `reset` y pulsa Enter.
- **No se ve nada en pantalla:** falta `refresh()` (o `wrefresh(ventana)`) después de dibujar.
- **El texto sale en otro sitio:** revisa el orden de las coordenadas. En ncurses la fila (`y`) va antes que la columna (`x`).
- **Las flechas no hacen nada:** falta `keypad(stdscr, TRUE)` en la ventana que estás leyendo, o comparas contra un `char`. Las flechas necesitan `int`.
- **El texto se escribe solo al pulsar teclas:** falta `noecho()`.
- **Un color se cuela en el resto de la pantalla:** falta `attroff(COLOR_PAIR(n))` después de pintar.
- **No se ve nada en un pad:** los pads usan `prefresh()`, no `wrefresh()`.
- **La primera tecla se «pierde» después de `resizeterm`:** ncurses encola un `KEY_RESIZE`; descártalo con un `getch()` antes de empezar a leer.
- **Una prueba falla:** compara tu salida carácter a carácter con la esperada.
- **Cambiaste el andamiaje:** usa **Tutor: Restablecer archivo del ejercicio** para volver a la plantilla.
