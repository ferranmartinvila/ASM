#include <stdio.h>
#include "mchar.h"
#include "mtbl.h"

mchar_t morse_table_alpha[] = {
    mchar(01), mchar(1000), mchar(1010), mchar(100), mchar(0), mchar(0010),
    mchar(110), mchar(0000), mchar(00), mchar(011), mchar(101), mchar(0100),
    mchar(11), mchar(10), mchar(11), mchar(0110), mchar(1101), mchar(010),
    mchar(000), mchar(1), mchar(001), mchar(0001), mchar(011), mchar(1001),
    mchar(1011), mchar(1100)
};

mchar_t morse_table_num[] = {
    mchar(11111), mchar(01111), mchar(00111), mchar(00011), mchar(00001),
    mchar(00000), mchar(10000), mchar(11000), mchar(11100), mchar(11110)
};


char mtbl_m2a(mchar_t c)
/* Donat un codi Morse m retorna el caràcter corresponent. En cas
que m no tingui un caràcter associat, retorna el caràcter NULL. */
{
    // Primer comprovo si és un espai
    if (c == 85)
        return ' ';

    // Itero la taula de números
    for(int i = 0; i < 10; i++) {
        if (morse_table_num[i] == c)
            return i + '0';
    }

    // Itero la taula de lletres
    for(int i = 0; i < 26; i++) {
        if (morse_table_alpha[i] == c)
            return i + 'A';
    }
}


mchar_t mtbl_a2m(char c)
/* Donat un caràcter c retorna el codi Morse corresponent. En cas
que no hi hagi cap codi Morse associat retorna un mchar_t buit. */
{
    if (c >= 'A' && c <= 'Z')
        return morse_table_alpha[c - 'A'];

    else if (c >= 'a' && c <= 'z')
        return morse_table_alpha[c - 'a'];

    else if (c >= '0' && c <= '9')
        return morse_table_num[c - '0'];

    else if (c == ' ')
        return mchar(01010);

    else
        return 0;

}
