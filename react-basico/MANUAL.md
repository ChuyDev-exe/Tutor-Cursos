# Manual de configuración

## Requisitos

| Herramienta | Versión mínima | Para qué |
|---|---|---|
| Node.js (`node`) | 16 | Ejecutar tus archivos `.js` y sus pruebas |

Este curso no necesita `npm install`, internet ni crear proyectos de React. Cada plantilla ya incluye un mini React (`h` y `renderToString`) para practicar la lógica con la misma forma de API.

## Instalación

- **macOS:** `brew install node`
- **Linux:** `sudo apt install nodejs`
- **Windows:** `winget install OpenJS.NodeJS.LTS`

Después de instalar, reinicia el editor para que encuentre `node`.

## Preparar el entorno

1. Abre una carpeta cualquiera como workspace del editor.
2. Ejecuta **Tutor: Verificar requisitos del curso**.
3. (Opcional) Ejecuta **Tutor: Ejecutar setup del curso**.
4. Abre el capítulo 1.
5. Lee el manual del capítulo antes de empezar los ejercicios.
6. Edita solo tu archivo `.js` del ejercicio. No modifiques la sección «Mini React del curso».

## Problemas comunes

- **«node no encontrado»:** reinicia el editor tras instalar Node para refrescar el PATH.
- **Una prueba falla:** abre el enunciado y compara tu salida carácter a carácter con la salida esperada. El espacio y el orden de las etiquetas importan.
- **Cambiaste el andamiaje:** usa **Tutor: Restablecer archivo del ejercicio** para volver a la plantilla.
- **¿Dónde está React de verdad?** Este curso enseña sus conceptos con la misma forma de API. Cuando crees tu propio proyecto React, instalarás `react` con tu gestor de paquetes.
