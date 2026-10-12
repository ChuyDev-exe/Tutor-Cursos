# Hook useCampo

Escribe el hook `useCampo(inicial)`, que guarda un texto en el estado y expone su manejador de input.

La plantilla ya trae el componente `Campo`, que pinta un `<input>`, un párrafo con el texto y su largo, y un botón reiniciar. No modifiques el componente; solo escribe el hook.

## Entrada

Dos partes, en este orden:

1. La primera línea es el texto inicial.
2. El resto son eventos:
   - `cambiar 1 texto` simula escribir en el input.
   - `clic 1` pulsa el botón «reiniciar».

## Salida

Una línea por cada render. El input se imprime con su atributo `value` y el párrafo con la forma `texto: <valor> · largo: <n>`.

## Ejemplo

Entrada:
```
inicio
cambiar 1 hola
clic 1
```

Salida:
```
<div><input value="inicio"></input><p>texto: inicio · largo: 6</p><button>reiniciar</button></div>
<div><input value="hola"></input><p>texto: hola · largo: 4</p><button>reiniciar</button></div>
<div><input value="inicio"></input><p>texto: inicio · largo: 6</p><button>reiniciar</button></div>
```
