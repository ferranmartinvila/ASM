#ifndef SEMAPH_H
#define SEMAPH_H

#include "lamp.h"

typedef enum {
    SemOff,
    SemClear,
    SemApproach,
    SemStop
} semaph_state_t;

typedef struct {
    lamp_t l;
    semaph_state_t s;
} semaph_t;

void semaph_init(semaph_t *const sem, volatile uint8_t *port_green, uint8_t pin_green, volatile uint8_t *port_yellow, uint8_t pin_yellow, volatile uint8_t *port_red, uint8_t pin_red);

void semaphore_set(semaph_t *const sem, semaph_state_t s);

semaph_state_t semaph_get(const semaph_t sem);

#endif
