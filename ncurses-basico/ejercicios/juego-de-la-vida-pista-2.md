La decisión por celda cabe en un `if` con dos ramas: si `g[f][c] == '#'`, la nueva celda es `'#'` solo con 2 o 3 vecinos vivos; si estaba muerta, nace solo con exactamente 3. Todo lo demás es `'.'`.
