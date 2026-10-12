# Funcion estable con callback

Memoriza el manejador de «sumar» con `useCallback`. El manejador lee el tope: no suma si llegaría a superarlo. Un `useEffect` con deps `[sumar]` imprime `manejador nuevo` cada vez que la identidad de `sumar` cambia.

`Contador({ topeInicial })` tiene dos estados: `n` (empieza en 0) y `tope` (empieza en `topeInicial`). El estado se llama `tope` para no chocar con la prop.

## Entrada

1. Línea 1: el valor inicial del tope. Si no hay líneas, empieza en 0.
2. Las siguientes son eventos:
   - `clic 1` → el botón «sumar», el manejador memorizado.
   - `clic 2` → el botón «subir tope», que incrementa el tope en 1.

## Salida

Una línea por cada render:

```
<div><p>valor: 0 tope: 2</p><button>sumar</button><button>subir tope</button></div>
```

Y, justo después del render que corresponda, el mensaje `manejador nuevo`. El mensaje aparece al montar y al cambiar el tope, pero no al cambiar solo `n`.

## Ejemplo

Entrada:
```
1
clic 2
clic 1
```

Salida:
```
<div><p>valor: 0 tope: 1</p><button>sumar</button><button>subir tope</button></div>
manejador nuevo
<div><p>valor: 0 tope: 2</p><button>sumar</button><button>subir tope</button></div>
manejador nuevo
<div><p>valor: 1 tope: 2</p><button>sumar</button><button>subir tope</button></div>
```
