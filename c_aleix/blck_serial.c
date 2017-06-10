#include "serial_device.h"
#include "blck_serial.h"
#include <string.h>
#include <ctype.h>

void print(char s[])
/* Envia per la UART el bloc de caràcters que se li passa com a
paràmetre. Quan troba el caràcter ’\0’ acaba. */
{
    int i = 0;

    while (i < strlen(s)) {
        serial_put(s[i]);
        i++;
    }
}


int readline(char s[], uint8_t m)
/* Va llegint caràcters i els va guardant a la taula s fins que troba
un caracter no gràfic (us pot ser útil la funció isgraph del header
ctype.h) o bé el nombre de caràcters iguala a m. El valor retornat
és el nombre de caràcters que ha llegit. */
{
    int i = 0;

    do {
        s[i] = serial_get();
        i++;
    } while (isgraph(s[i-1]) && i < m);

    return i;
}
