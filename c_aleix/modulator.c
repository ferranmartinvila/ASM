#include <avr/io.h>
#include "modulator.h"

void modulator_init(void)
/*Inicialitza el mòdul. Després de la inicialització el senyal de
sortida és baix.*/
{
  //Utilització del Timer 2, ja que amb el Timer 0 un dels ports està ocupat pel led de la shield

  //Configuració del mode CTC
  TCCR2A = (1 << WGM21);

  //Configuració del preescaler
  TCCR2B = (1 << CS22)|(1 << CS20);

  //Configuració del port del timer, reseteig i configuració com a output
  OCR2A = OCR2A_valor;
  PORTB &= ~(1 << PB3);
  DDRB |= (1 << PB3);
}


void modulator_set(bool l)
/*Canvia l’estat del senyal de sortida. Si l és true activa la genera-
ció de portadora, si és false desactiva la generació de portadora.*/
{
  //Configuració del mode toggle
  if (l){
    TCNT2 = 0;
    TCCR2A |= (1 << COM2A0);
  }
  else{
    TCCR2A &= ~(1 << COM2A0);
  }
}
