#include <stdbool.h>
#include <stdio.h>
#ifndef GPIO_DEVICE_H
#define GPIO_DEVICE_H

typedef enum {Input, Output} pin_direction_t;

typedef struct {
    volatile uint8_t *port;
    uint8_t pin;
} pin_t;

pin_t pin_bind(volatile uint8_t *port, uint8_t pin, pin_direction_t d);

void pin_w(pin_t p, bool v);

bool pin_r(pin_t p);

void pin_toggle(pin_t p);

void pin_unbind(pin_t *const p);

#endif
