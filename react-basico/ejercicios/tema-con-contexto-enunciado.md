# Tema con contexto

Comparte el tema visual con `useContext`. El componente `Etiqueta` lee el tema del contexto sin recibir props, y un botón lo alterna.

## Entrada

Dos tipos de líneas:

1. La primera es el tema inicial: `claro` u `oscuro`. Si no hay ninguna línea, el tema inicial es `claro`.
2. Las siguientes son eventos, uno por línea:
   - `clic 1` → alterna el tema.

## Salida

Una línea por cada render. El Provider es transparente: no añade ninguna etiqueta al HTML.

Cada línea contiene el `span` de `Etiqueta` y el botón:

```
<span className="claro">tema: claro</span><button>alternar</button>
```

## Ejemplo

Entrada:
```
claro
clic 1
```

Salida:
```
<span className="claro">tema: claro</span><button>alternar</button>
<span className="oscuro">tema: oscuro</span><button>alternar</button>
```
