#include <avr/io.h>
#include "gpio_device.h"

pin_t pin_bind(volatile uint8_t *port, uint8_t pin, pin_direction_t d)
/*Retorna un objecte pin t associat al pin número pin del port port
i inicialitzat en mode d.*/
{
    // Crea el pin p i el configura
    pin_t p;
    p.port = port;
    p.pin = pin;

    // Selecciona el corresponent DDRx i el posa en mode Input / Output
    volatile uint8_t *ddr = port - 1;
    (d==Output) ? (*ddr |= _BV(pin)) : (*ddr &= ~(_BV(pin)));

    return p;
}

void pin_w(pin_t p, bool v)
/*Escriu un valor en el pin p. p ha d’estar associat i en mode
Output per a que la funció tingui efecte.*/
{
    // Comprova que estigui associat
    if(p.port != NULL){
        // Selecciona el corresponent DDRx i comprova si està en Output
        volatile uint8_t *ddr = p.port - 1;
        if(*ddr & (_BV(p.pin))){
            // Escriu
            (v) ? (*p.port |= _BV(p.pin)) : (*p.port &= ~(_BV(p.pin)));
        }
    }
}

bool pin_r(pin_t p)
/*Llegeix un valor del pin p. p ha d’estar associat.*/
{
    // Comprova que estigui associat
    if(p.port != NULL){
        // Selecciona el corresponent PINx
        volatile uint8_t *pinx = p.port - 2;

        // Retorna el seu valor
        return (*pinx & (_BV(p.pin)));
    }
}

void pin_toggle(pin_t p)
/*Commuta el valor del pin p. p ha d’estar associat i en mode
Output.*/
{
    // Comprova que estigui associat
    if(p.port != NULL){
        // Selecciona el corresponent DDRx i comprova si està en Output
        volatile uint8_t *ddr = p.port - 1;
        if(*ddr & (_BV(p.pin))){
            // Commuta
            *p.port ^= _BV(p.pin);
        }
    }
}

void pin_unbind(pin_t *const p)
/*Desassocia el pin p d’un pin fı́sic.*/
{
    pin_t p2;
    p2.port;
    p2.pin;

    *p = p2;
}
