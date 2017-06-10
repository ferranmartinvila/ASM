#include "control.h"
#include "timer.h"
#include <avr/io.h>
#include <avr/interrupt.h>

semaph_t semA, semB;
int tick;
timer_handler_t h;

void control_init(void)
/* Inicialitza el mòdul de control. Es imprescindible cridar la funció
 abans d’usar el mòdul. Una vegada inicialitzat deixa els
semàfors apagats i cal engegar-los explícitament. */
{
    semaph_init(&semA, &PORTD, 5, &PORTD, 6, &PORTD, 7); // 5,6,7
    semaph_init(&semB, &PORTD, 4, &PORTC, 3, &PORTC, 2); // 4,3,2
    timer_init();
}

void control_force(street_t t)
/* Força el carrer t a l’estat Clear. Respecta els temps de seguretat
establerts (vegeu descripció posterior). */
{
    // Primer comprovo que els semàfors no estiguin apagats
    if (control_get_state(StreetA) != SemOff) {
        switch (t) {
            // Poso el B en vermell i l'A en verd...
            case StreetA:
            {
                // ... passant per àmbar si fa falta
                if (control_get_state(StreetB) == SemClear) {
                    semaphore_set(&semB, SemApproach);

                    tick = 45; // 45
                    break;
                }

                semaphore_set(&semB, SemStop);
                semaphore_set(&semA, SemClear);

                tick = 0; // 50
                break;
            }

            // Poso el A en vermell i el B en verd...
            case StreetB:
            {
                // ... passant per àmbar si fa falta
                if (control_get_state(StreetA) == SemClear) {
                    semaphore_set(&semA, SemApproach);

                    tick = 20; // 20
                    break;
                }

                semaphore_set(&semA, SemStop);
                semaphore_set(&semB, SemClear);

                tick = 25; // 25
                break;
            }
        }
    }
}

void control_off(void)
/* Apaga els semàfors de la cruïlla. */
{
    // Primer comprovo que els semàfors no estiguin apagats
    if (control_get_state(StreetA) != SemOff) {
        // Apago els dos semàfors
        semaphore_set(&semA, SemOff);
        semaphore_set(&semB, SemOff);

        // Deshabilito el timer
        timer_cancel(h);
    }
}

void automat()
/* Autòmat que controla l'estat */
{
    if(control_get_state(StreetA) != SemOff){
        tick += 1;
        if(tick == 20){
            semaphore_set(&semA, SemApproach);
        } else if(tick == 25){
            semaphore_set(&semA, SemStop);
            semaphore_set(&semB, SemClear);
        } else if(tick == 45){
            semaphore_set(&semB, SemApproach);
        } else if(tick == 50){
            semaphore_set(&semB, SemStop);
            semaphore_set(&semA, SemClear);
            tick = 0;
        }
    }
}


void control_on(void)
/* Engega els semàfors de la cruïlla. */
{
    // Primer comprovo que els semàfors estiguin apagats
    if (control_get_state(StreetA) == SemOff) {
        // Engego els dos semàfors, en estat Aclear
        semaphore_set(&semA, SemClear);
        semaphore_set(&semB, SemStop);

        // Habilito el timer
        h = timer_every(TIMER_MS(100), automat);

        // Poso el tick a 0
        tick = 0;
    }
}

semaph_state_t control_get_state(street_t s)
/* Retorna l’estat del semàfor del carrer s. */
{
    switch (s) {
        case StreetA:
        {
            return semaph_get(semA);
        }
        case StreetB:
        {
            return semaph_get(semB);
        }
    }
}
