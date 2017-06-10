#include "modulator.h"
#include <util/delay.h>

int main(void)
{
    modulator_init();
    modulator_set(true);
    _delay_ms(5000);
    modulator_set(false);
}
