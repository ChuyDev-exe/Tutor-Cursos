# Calculadora de teclas

Completa la función `calcular` del script. Es la lógica de una calculadora de escritorio: recibe la cadena de teclas que el usuario pulsó (dígitos, operadores, `c` y `=`), la procesa carácter a carácter y deja en `display` el texto visible.

El andamiaje ya leyó la línea entera con `fgets` y ya dibuja `display` en una ventana con borde. Tú solo procesas la cadena: **no hace falta `getch()`**.

Edita solo la función marcada con `TODO`.

## Teclas

| Tecla | Efecto |
|---|---|
| `0`-`9` | acumula el dígito en el número en curso |
| `+` `-` `*` `/` | fija el operador (o encadena la operación pendiente) |
| `c` | reinicia todo; `display` queda en `0` |
| `=` | aplica la operación y muestra el resultado |
| cualquier otra | se ignora (por ejemplo el salto de línea) |

## Las tres fases

La calculadora tiene dos operandos y un operador. El estado se guarda en cuatro variables: `long izq`, `long der`, `char op` y `int fase`.

- **fase 0** — escribes el primer número (`izq`). Empiezas aquí.
- **fase 1** — hay un operador pendiente esperando el segundo número.
- **fase 2** — escribes el segundo número (`der`).

Reglas:

1. **Dígito:** en fase 0, `izq = izq * 10 + d`; en fase 2, `der = der * 10 + d`; en fase 1 se ignora.
2. **Operador en fase 0 o 1:** guarda `op = tecla`, `der = 0` y pasa a **fase 2**.
3. **Operador en fase 2:** primero aplica la operación pendiente (`izq = izq OP der`), después guarda el nuevo `op`, pon `der = 0` y sigues en **fase 2**. Así encadenas: `2+3=*10=` hace 5 y luego 50.
4. **`c`:** `izq = 0`, `der = 0`, `op = 0`, fase 0 y `display` = `0`.
5. **`=` en fase 2:** aplica la operación, deja el resultado en `izq`, vuelve a **fase 0** y muestra el resultado. En fase 0 o 1, `=` no hace nada.
6. **División entera** como en C. Si `der` es 0, el resultado es 0 (nunca dividas entre 0).

## El display

`display` es un búfer de `DISPLAY_TAM` (32) bytes. Tú lo actualizas tras cada tecla con `snprintf` (nunca `sprintf`, así no desbordas):

| Fase | Formato |
|---|---|
| 0 | `"%ld"` → `izq` |
| 1 | `"%ld %c"` → `izq` y `op` |
| 2 | `"%ld %c %ld"` → `izq`, `op` y `der` (con un espacio alrededor del operador) |

Tras un `=` válido la fase vuelve a 0, así que `display` muestra solo el resultado. `calcular` devuelve el valor final: el resultado del último `=` o, si no hubo `=`, `izq` tal cual está.

## Entrada

Una línea con las teclas pulsadas, por ejemplo `12+3=`.

## Salida

El andamiaje imprime el texto del display y el valor devuelto:

```
pantalla=<texto del display>
resultado=<long devuelto por calcular>
```

## Ejemplo

Entrada: `12+3=`  →  Salida:

```
pantalla=15
resultado=15
```

Edita solo la función marcada con `TODO`.
