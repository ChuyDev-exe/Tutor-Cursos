En `nm -m`, los campos son: `$1` dirección, `$2` la sección entre paréntesis, `$3` el tipo (`external`) y `$4` el nombre. Quita los paréntesis con `gsub(/[()]/,"",$2)`.
