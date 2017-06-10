#include <stdio.h>
#include "mchar.h"

mchar_t mchar_add(mchar_t m, msign_t s)
/* Retorna el resultat d’afegir a m un nou signe s. Si m ja contenia
5 signes, el resultat és erroni. Noteu que l’expressió
mchar add(mchar(0),MDash), per exemple, equival al codi Morse
de la lletra A. */
{
    if (mchar_len(m) >= 5) {
        printf("Error \n");
        return 0;

    } else {
        // Interpreto el símbol
        uint8_t simbol;
        switch (s) {
            case MDot:
                simbol = 0;
                break;
            case MDash:
                simbol = 1;
                break;
        }


        uint8_t new_c = m >> (8 - mchar_len(m) - 1) | simbol; // Creo el nou caràcter
        uint8_t new_len = mchar_len(m) + 1; // Incremento en 1 la longitud

        mchar_t new_m = new_c << (8 - new_len) | new_len; // Genero el nou mchar_t

        return new_m;
    }
}


mchar_iter_t mchar_iter(mchar_t m)
/* Donat un codi m retorna un iterador inicialitzat sobre el primer
signe. */
{
    mchar_iter_t i;
    i.m = m;
    i.mask = 1;
    i.sentinel = mchar_len(m) + 1;

    return i;
}


msign_t mchar_next(mchar_iter_t *const i)
/* Torna el signe que indica l’iterador i posteriorment l’avança. */
{
    uint8_t sign = (i->m >> (8 - i->mask++)) & 1;

    switch (sign) {
        case 0:
            return MDot;
        case 1:
            return MDash;
    }
}


bool mchar_valid(mchar_iter_t i)
/* Retorna true si l’iterador i està sobre un signe i se li pot aplicar
l’operació mchar_next(). */
{
    return (i.mask >= 1) && (i.mask < i.sentinel);
}
