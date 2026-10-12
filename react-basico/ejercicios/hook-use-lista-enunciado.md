# Hook useLista

Escribe el hook `useLista(inicial)`, que guarda un array en el estado y lo gestiona sin mutarlo.

La plantilla ya trae el componente `Lista`, que pinta los items dentro de un `<ul>` y tres botones: agregar pan, quitar pan y agregar agua. No modifiques el componente; solo escribe el hook.

`agregar(x)` añade `x` al final si aún no estaba. Si ya estaba, deja la lista igual, sin duplicar. `quitar(x)` devuelve la lista sin las copias de `x`.

## Entrada

Dos partes, en este orden:

1. La primera línea son los items iniciales separados por espacio. Puede venir vacía.
2. El resto son eventos:
   - `clic 1` pulsa «agregar pan».
   - `clic 2` pulsa «quitar pan».
   - `clic 3` pulsa «agregar agua».

## Salida

Una línea por cada render: el inicial y uno tras cada evento.

Quitar un elemento que no estaba deja el mismo contenido y vuelve a imprimir la misma línea.

## Ejemplo

Entrada:
```
agua
clic 1
clic 2
```

Salida:
```
<div><ul><li key="agua">agua</li></ul><button>agregar pan</button><button>quitar pan</button><button>agregar agua</button></div>
<div><ul><li key="agua">agua</li><li key="pan">pan</li></ul><button>agregar pan</button><button>quitar pan</button><button>agregar agua</button></div>
<div><ul><li key="agua">agua</li></ul><button>agregar pan</button><button>quitar pan</button><button>agregar agua</button></div>
```
