El bucle es de 20 pasos fijos, `for (int paso = 0; paso < 20; paso++)`. En cada paso: `mvaddch(2, 2 + paso, '#'); refresh(); getch();`. No necesitas guardar el valor que devuelve `getch()`.
