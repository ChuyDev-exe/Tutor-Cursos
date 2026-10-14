`wgetnstr(stdscr, buffer, max)` lee hasta Enter o `max` caracteres y añade `\0` al final. Antes de cada lectura, coloca el cursor donde debe escribirse el dato con `wmove`.
