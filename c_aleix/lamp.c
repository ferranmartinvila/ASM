#include <stdbool.h>

#include "lamp.h"

void lamp_init(lamp_t *const l, volatile uint8_t *prtg, uint8_t pg, volatile uint8_t *prty, uint8_t py, volatile uint8_t *prtr, uint8_t pr)
/* Fa el bind entre un lamp t i cadascun dels 3 pins físics. Inicialitza
el lamp t amb tots els LED apagats. */
{
    // Associo cada pin
    l->green = pin_bind(prtg, pg, Output);
    l->yellow = pin_bind(prty, py, Output);
    l->red = pin_bind(prtr, pr, Output);

    // Apago els leds
    pin_w(l->green, 0);
    pin_w(l->yellow, 0);
    pin_w(l->red, 0);
}


void lamp_on(lamp_t l, color_t c)
/* Encen el LED de color c de la l`ampada l. */
{
    switch (c) {
        case Green:
        {
            // Encenc el led verd
            pin_w(l.green, 1);
            break;
        }
        case Yellow:
        {
            // Encenc el led groc
            pin_w(l.yellow, 1);
            break;
        }
        case Red:
        {
            // Encenc el led vermell
            pin_w(l.red, 1);
            break;
        }
    }
}


void lamp_off(lamp_t l, color_t c)
/* Apaga el LED de color c de la l`ampada l. */
{
    switch (c) {
        case Green:
        {
            // Apago el led verd
            pin_w(l.green, 0);
            break;
        }
        case Yellow:
        {
            // Apago el led groc
            pin_w(l.yellow, 0);
            break;
        }
        case Red:
        {
            // Apago el led vermell
            pin_w(l.red, 0);
            break;
        }
    }
}


void lamp_toggle(lamp_t l, color_t c)
/* Commuta l’estat del color c en la l`ampada l. */
{
    switch (c) {
        case Green:
        {
            // Commuto el led verd
            pin_toggle(l.green);
            break;
        }
        case Yellow:
        {
            // Commuto el led groc
            pin_toggle(l.yellow);
            break;
        }
        case Red:
        {
            // Commuto el led vermell
            pin_toggle(l.red);
            break;
        }
    }
}


bool lamp_is_on(lamp_t l, color_t c)
/* Retorna true sii en la l`ampada l el color c est`a enc`es */
{
    switch (c) {
        case Green:
        {
            // Retorna ture ssi està encés el led verd
            return pin_r(l.green);
        }
        case Yellow:
        {
            // Retorna ture ssi està encés el led groc
            return pin_r(l.yellow);
        }
        case Red:
        {
            // Retorna ture ssi està encés el led vermell
            return pin_r(l.red);
        }
    }
}
