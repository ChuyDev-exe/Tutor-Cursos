Los símbolos locales no salen del archivo en el que están: el enlazador los resuelve ahí mismo y los tira. Por eso en el ejecutable solo aparece `_saluda`, y también `_main`, que hay que filtrar.
