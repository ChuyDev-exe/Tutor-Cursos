# Manual de configuración

## Requisitos

| Herramienta | Versión mínima | Para qué |
|---|---|---|
| GCC o Clang (`gcc`) | 9 | Compilar los programas en C |
| SDL2 (`sdl2-config`) | 2.0.10 | La biblioteca SDL y sus cabeceras; `sdl2-config` da las opciones para compilar |
| `bash` | 3.2 | Ejecutar los scripts de los ejercicios |

Los ejercicios no abren ventanas: funcionan también sin pantalla.

## Instalación

- **macOS:** `xcode-select --install` y después `brew install sdl2` (necesitas [Homebrew](https://brew.sh)).
- **Linux (Debian/Ubuntu):** `sudo apt install build-essential libsdl2-dev`.
- **Linux (Fedora):** `sudo dnf install gcc SDL2-devel`.
- **Windows:** instala WSL con `wsl --install` y sigue los pasos de Linux dentro de WSL.

Comprueba la instalación; las dos líneas deben responder sin error:

```bash
gcc --version
sdl2-config --version
```

## Preparar el entorno

1. Abre una carpeta cualquiera como workspace del editor.
2. Ejecuta **Tutor: Verificar requisitos del curso**.
3. Ejecuta **Tutor: Ejecutar setup del curso**. Debe terminar con «Listo».
4. Abre el capítulo 1 y lee su manual.
5. Cada ejercicio es un archivo `.sh`. Edita solo la parte marcada con `TODO`.

## Problemas comunes

- **«sdl2-config: command not found»:** SDL2 no está instalado, o su carpeta no está en el PATH. En macOS revisa que `brew` funcione y reinicia el editor.
- **«SDL.h: No such file or directory»:** compila con `$(sdl2-config --cflags --libs)`; esas opciones dicen dónde están las cabeceras.
- **«undefined reference to `SDL_main`» o error con `main`:** escribe `int main(int argc, char *argv[])`, con los dos parámetros.
- **El jugador se mueve al revés en vertical:** en SDL el eje y crece hacia abajo. La flecha de arriba resta a `y`.
- **Una prueba falla:** compara tu salida carácter a carácter con la esperada.
- **Cambiaste el andamiaje:** usa **Tutor: Restablecer archivo del ejercicio** para volver a la plantilla.
