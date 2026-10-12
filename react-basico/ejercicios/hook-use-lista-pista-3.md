La forma de la función es esta, sin la parte clave de cada línea:

```js
function useLista(inicial) {
  const [items, setItems] = useState(inicial);
  const agregar = (x) => setItems((prev) => (prev.includes(x) ? /* aquí */ : /* aquí */));
  const quitar = (x) => setItems(/* aquí */);
  return /* aquí */;
}
```
