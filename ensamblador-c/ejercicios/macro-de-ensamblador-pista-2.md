`nm` solo entiende archivos objeto. Si le pasas texto de ensamblador, falla y la línea sale vacía: comprueba con `nm suma.o | awk '$3=="_suma"{print $2" "$3}'` que devuelve `T _suma`.
