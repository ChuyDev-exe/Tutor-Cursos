Actualiza con actualización funcional y copia superficial: `setEstado((e) => ({ ...e, n: e.n + 1, veces: e.veces + 1 }))`. Nunca asignes `estado.n = ...`: React no vería el cambio.
