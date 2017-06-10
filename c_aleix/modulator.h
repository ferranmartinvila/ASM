#ifndef MODULATOR_H
#define MODULATOR_H
#include <stdio.h>
#include <stdbool.h>

#define TEMPS_COMPARACIO 3100
#define PRESCALERM 128
#define OCR2A_valor ((uint8_t) (F_CPU/(2.0*PRESCALERM*TEMPS_COMPARACIO)-1))

void modulator_init(void);

void modulator_set(bool l);


#endif
