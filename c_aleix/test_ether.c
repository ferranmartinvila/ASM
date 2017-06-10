#include "ether.h"

void main(void)
{
    ether_init();
    ether_put('a');
    ether_put('R');
    ether_put('A');
    ether_put(' ');
    for(;;);

}
