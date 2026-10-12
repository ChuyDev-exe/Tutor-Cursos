# Manual de configuración

## Requisitos

| Herramienta | Versión mínima | Para qué |
|---|---|---|
| GCC / Clang (`gcc`) | 9 | Compilar C y ensamblar con `as` (viene con Xcode) |
| GNU Make (`make`) | 3.81 | Ejecutar los Makefiles de los ejercicios |

El resto de herramientas del curso (`as`, `clang`, `nm`, `ar`, `objdump`) se instalan junto con `gcc`: son parte de las herramientas de desarrollador de Xcode. No necesitas `npm`, `pip` ni descargas externas.

**Importante:** los ejercicios ejecutables de este curso están hechos para **macOS con chip Apple (arm64)**. El capítulo de x86-64 y GNU/Linux es teórico: se lee, se evalúa y no requiere instalar nada.

## Instalación

- **macOS:** abre una terminal y ejecuta `xcode-select --install`. Si ya tienes Xcode o las herramientas de desarrollador, no hace falta nada más.
- **Linux:** `sudo apt install build-essential make`. Podrás leer el curso; los comandos de ensamblador de los ejercicios usan la sintaxis y el formato de macOS.
- **Windows:** instala WSL con `wsl --install` y sigue los pasos de Linux dentro de WSL.

Comprueba la instalación con estas tres líneas; las tres deben responder sin error:

```bash
gcc --version
as --version
make --version
```

## Preparar el entorno

1. Abre una carpeta cualquiera como workspace del editor.
2. Ejecuta **Tutor: Verificar requisitos del curso**.
3. (Opcional) Ejecuta **Tutor: Ejecutar setup del curso**.
4. Abre el capítulo 1.
5. Lee el manual del capítulo antes de empezar los ejercicios.
6. Cada ejercicio de ensamblador es un archivo `.sh` (o `.c`) que escribe el código, lo ensambla, lo enlaza y lo ejecuta. Edita solo las partes marcadas con `TODO`.

## Problemas comunes

- **«gcc no encontrado»:** ejecuta `xcode-select --install` y reinicia el editor para refrescar el PATH.
- **«ld: symbol(s) not found»:** falta la definición de una función. Revisa que la etiqueta exista en el `.s`, que sea global (`.globl`) y que esté en la línea de enlace.
- **«duplicate symbol»:** estás definiendo dos veces la misma función. Debe existir una sola definición.
- **El programa se cuelga o termina sin imprimir:** revisa que el prólogo guarde `x30` en la pila y que el epílogo lo restaure antes del `ret`.
- **Los argumentos de printf o scanf llegan raros:** en macOS con chip Apple van en la pila (`[sp+0]`, `[sp+8]`…), no en `x1`, `x2`. Revisa el capítulo 3.
- **Una prueba falla:** compara tu salida carácter a carácter con la esperada. El espacio, el orden y las mayúsculas importan.
- **Cambiaste el andamiaje:** usa **Tutor: Restablecer archivo del ejercicio** para volver a la plantilla.
