# Tutor-Cursos

Cursos para [Tutor IDE](https://github.com/ChuyDev-exe/vscode-tutor-ext), la extensión de VS Code para aprender programación con capítulos, ejercicios con pruebas automáticas y evaluaciones.

La extensión lee este repositorio directamente desde GitHub. Cada carpeta con un `curso.json` es un curso.

## Instalar un curso

1. Instala la extensión **Tutor IDE** en VS Code.
2. Abre la vista **Tutor IDE → Buscar → Repositorio**.
3. Haz clic en el curso. Se abre su ficha con el temario, la duración y los requisitos.
4. Pulsa **Descargar**.

Si ya tienes un curso y aquí hay una versión nueva, la ficha muestra **Actualizar**. Al actualizar se conservan tu progreso y tus archivos.

## Cursos

| Curso | Nivel | Capítulos | Duración | Versión | Carpeta |
|---|---|---|---|---|---|
| Ensamblador y C: de instrucciones a ejecutables | intermedio | 12 | 4 h 8 min | 1.2.0 | [`ensamblador-c`](ensamblador-c/) |
| ncurses: interfaces de texto en C | principiante | 10 | 4 h 30 min | 2.0.0 | [`ncurses-basico`](ncurses-basico/) |
| React desde cero | principiante | 11 | 4 h 15 min | 1.2.0 | [`react-basico`](react-basico/) |
| SDL2: primeros pasos para juegos en C | principiante | 1 | 25 min | 1.0.0 | [`sdl-basico`](sdl-basico/) |

La duración es la suma de los `minutos` de los capítulos.

## Publicar un curso

1. Crea una carpeta nueva en la raíz con un `curso.json`. Su nombre debe coincidir con el `id` del curso (minúsculas y guiones). Sigue el formato de [CURSOS.md](https://github.com/ChuyDev-exe/vscode-tutor-ext/blob/main/docs/CURSOS.md) y la guía [CREAR-CURSO-CON-IA.md](https://github.com/ChuyDev-exe/vscode-tutor-ext/blob/main/docs/CREAR-CURSO-CON-IA.md).
2. Rellena la ficha: `descripcion`, `nivel`, `requisitos` y, en cada capítulo, `descripcion` y `minutos`.
3. Valida con la extensión clonada junto a este repositorio (`../vscode-tutor-ext`, tras `npm ci && npm run compile`):
   ```bash
   node ../vscode-tutor-ext/scripts/validate-course.js <carpeta>
   node ../vscode-tutor-ext/scripts/check-solutions.js <carpeta>
   ```
   Los dos deben terminar sin errores.
4. Sube los cambios a `main`. El curso aparece en **Buscar → Repositorio**.

**Al actualizar un curso publicado**, sube su `version` (por ejemplo, 1.1.0 → 1.2.0) para que quien lo tiene vea **Actualizar**. No cambies ni reutilices los `id` de capítulos, ejercicios o preguntas: el progreso de los alumnos se guarda por esos ids. Añade la fila nueva o los cambios a la tabla de este README.
