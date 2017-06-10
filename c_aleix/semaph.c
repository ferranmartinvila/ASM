#include "semaph.h"

void semaph_init(semaph_t *const sem, volatile uint8_t *port_green, uint8_t pin_green, volatile uint8_t *port_yellow, uint8_t pin_yellow, volatile uint8_t *port_red, uint8_t pin_red)
/* Inicialitza el mòdul. Cal cridar-la obligatòriament abans d’usar
cap altra funció del mòdul. Els paràmetres port X i pin X indiquen
on es troba connectada la l`ampada. Una vegada inicialitzat
el mòdul el semàfor es troba en estat SemOff. */
{
    // Inicialitzo la lampada del semàfor
    lamp_init(&sem->l, port_green, pin_green, port_yellow, pin_yellow, port_red, pin_red);

    // Poso l'estat del semàfor en off
    sem->s = SemOff;

    // Apago els leds
    lamp_off(sem->l, Green);
    lamp_off(sem->l, Yellow);
    lamp_off(sem->l, Red);
}


void semaphore_set(semaph_t *const sem, semaph_state_t s)
/* Força el semàfor sem a un estat concret determinat pel
paràmetre s. */
{
    switch (s) {
        case SemOff:
        {
            sem->s = SemOff;

            // Poso els leds en l'estat corresponent
            lamp_off(sem->l, Green);
            lamp_off(sem->l, Yellow);
            lamp_off(sem->l, Red);
            break;
        }
        case SemClear:
        {
            sem->s = SemClear;

            // Poso els leds en l'estat corresponent
            lamp_on(sem->l, Green);
            lamp_off(sem->l, Yellow);
            lamp_off(sem->l, Red);
            break;
        }
        case SemApproach:
        {
            sem->s = SemApproach;

            // Poso els leds en l'estat corresponent
            lamp_off(sem->l, Green);
            lamp_on(sem->l, Yellow);
            lamp_off(sem->l, Red);
            break;
        }
        case SemStop:
        {
            sem->s = SemStop;

            // Poso els leds en l'estat corresponent
            lamp_off(sem->l, Green);
            lamp_off(sem->l, Yellow);
            lamp_on(sem->l, Red);
            break;
        }
    }
}


semaph_state_t semaph_get(const semaph_t sem)
/* Retorna l’estat en que es troba el semàfor sem. */
{
    return sem.s;
}
