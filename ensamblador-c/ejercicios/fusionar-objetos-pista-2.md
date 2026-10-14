Para fusionar objetos sin enlazar el programa completo se usa `ld -r a.o b.o -o todo.o`. La opción `-r` (relocatable) produce un `.o` nuevo con las secciones ya unidas.
