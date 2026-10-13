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

## Problemas comunes

- **«ncurses.h: No such file or directory»:** faltan las cabeceras. En Linux instala `libncurses-dev` (o `ncurses-devel`).
- **«undefined reference to `initscr`» o «Undefined symbols»:** falta `-lncurses` en la línea de `gcc`.
- **La terminal quedó rara después de un programa:** el programa terminó sin `endwin()`. Escribe `reset` y pulsa Enter.
- **No se ve nada en pantalla:** falta `refresh()` (o `wrefresh(ventana)`) después de dibujar.
- **El texto sale en otro sitio:** revisa el orden de las coordenadas. En ncurses la fila (`y`) va antes que la columna (`x`).
- **Una prueba falla:** compara tu salida carácter a carácter con la esperada.
- **Cambiaste el andamiaje:** usa **Tutor: Restablecer archivo del ejercicio** para volver a la plantilla.
