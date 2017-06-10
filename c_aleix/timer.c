#include <avr/io.h>
#include <util/atomic.h>
#include <avr/interrupt.h>
#include "timer.h"


typedef struct {
    uint8_t remaining, every, ntimes;
    timer_callback_t callback;
} entry;

static struct {
    entry t[N];
    uint8_t n;
} tt;

static bool timerinit = false;


void timer_init(void)
/*Inicialitza el mòdul. Cal cridar-la com a mínim una vegada
abans d'usar el mòdul. Només pot cridar-se amb les interrupcions inhabilitades.*/
{
  // Inicialització de les tasks table(tt) amb entries buides
  for (uint8_t i = 0; i < N; i++) {
      tt.t[i].every = 0;
  }

  //Configuració del mode CTC
  TCCR1B = (1 << WGM12);

  //Configuració del preescaler
  TCCR1B |= (1 << CS11);

  //Mode normal port operation
  TCCR1A = 0;

  //Configuració del port del timer
  OCR1A = OCR1A_valor;

  //Habilitació interrupcions globals
  sei();
  timerinit = true;

  return;
}

timer_handler_t timer_after(uint8_t ticks, timer_callback_t f)
/*Planifica la funció f() per a ser executada al cap de ticks ticks.
Retorna un handler que identifica aquesta acció planificada o
bé val TIMER ERR en cas que l'acció no es pugui planificar per
alguna raó.*/
{
  entry ent;

  if (timerinit) {
    ent.remaining = ticks;
    ent.every = ticks;
    ent.ntimes = 1;
    ent.callback = f;

    uint8_t i = 0;

    ATOMIC_BLOCK(ATOMIC_FORCEON) {

        // Si esta buida, comença a la primera posició
        if (tt.n == 0) {
            tt.t[0] = ent;
            tt.n++;

            // Activa interrupcions(CTC)
            TIMSK1 = 0b00000010;

            return 0;

        // Si no està buida, busca següent
        } else if (tt.n < N) {

            // Comprovar següent entry
            if (tt.t[tt.n].every == 0) {
                tt.t[tt.n] = ent;
                i = tt.n;
                tt.n++;
                return i;

        // Si esta ple, sobreescriu entry buida
        } else {
                while (i < N) {
                    if (tt.t[i].every == 0) {
                        tt.t[i] = ent;
                        tt.n++;
                        return i;
                    } i++;
                }

                // Si no, error
                return TIMER_ERR;
            }

        // Si està ple, error
        } else {
            return TIMER_ERR;
        }
    }
  } else {
    return TIMER_ERR;
  }
}


timer_handler_t timer_every(uint8_t ticks, timer_callback_t f)
/*Planifica la funció f() per a ser executada cada ticks ticks de
manera indefinida. Retorna un handler que identifica aquesta
acció planificada o bé val TIMER ERR en cas que l'acció no es
pugui planificar per alguna raó.*/
{
  entry ent;

  if (timerinit) {
    ent.remaining = ticks;
    ent.every = ticks;
    ent.ntimes = 0;
    ent.callback = f;

    uint8_t i = 0;

    ATOMIC_BLOCK(ATOMIC_FORCEON) {

        // Si esta buida, comença a la primera posició
        if (tt.n == 0) {
            tt.t[0] = ent;
            tt.n++;

            // Activa interrupcions(CTC)
            TIMSK1 = 0b00000010;

            return 0;

        // Si no està buida, busca següent
        } else if (tt.n < N) {

            // Comprovar següent entry
            if (tt.t[tt.n].every == 0) {
                tt.t[tt.n] = ent;
                i = tt.n;
                tt.n++;
                return i;

        // Si esta ple, sobreescriu entry buida
        } else {
                while (i < N) {
                    if (tt.t[i].every == 0) {
                        tt.t[i] = ent;
                        tt.n++;
                        return i;
                    } i++;
                }

                // Si no, error
                return TIMER_ERR;
            }

        // Si està ple, error
        } else {
            return TIMER_ERR;
        }
    }
  } else {
    return TIMER_ERR;
  }

}


timer_handler_t timer_ntimes(uint8_t n, uint8_t ticks, timer_callback_t f)
/*Planifica la funció f() per a ser executada cada ticks ticks n vegades.
Retorna un handler que identifica aquesta acció planificada
o bé val TIMER ERR en cas que l'acció no es pugui planificar
per alguna raó. En cas que n sigui zero s'interpreta que la
funció ha de ser cridada indefinidament. Noteu que aquesta funció
subsumeix les dues anteriors.*/
{
  entry ent;

  if (timerinit) {
    ent.remaining = ticks;
    ent.every = ticks;
    ent.ntimes = n;
    ent.callback = f;

    uint8_t i = 0;

    ATOMIC_BLOCK(ATOMIC_FORCEON) {

        // Si esta buida, comença a la primera posició
        if (tt.n == 0) {
            tt.t[0] = ent;
            tt.n++;

            // Activa interrupcions(CTC)
            TIMSK1 = 0b00000010;

            return 0;

        // Si no està buida, busca següent
        } else if (tt.n < N) {

            // Comprovar següent entry
            if (tt.t[tt.n].every == 0) {
                tt.t[tt.n] = ent;
                i = tt.n;
                tt.n++;
                return i;

        // Si esta ple, sobreescriu entry buida
        } else {
                while (i < N) {
                    if (tt.t[i].every == 0) {
                        tt.t[i] = ent;
                        tt.n++;
                        return i;
                    } i++;
                }

                // Si no, error
                return TIMER_ERR;
            }

        // Si està ple, error
        } else {
            return TIMER_ERR;
        }
    }
  } else {
    return TIMER_ERR;
  }

}

void timer_cancel(timer_handler_t h)
/*Cancel·la l'acció planificada identificada per h. Si h no és un
handler vàlid, no fa res.*/
{
  ATOMIC_BLOCK(ATOMIC_FORCEON) {
      // Tasks table buida o handler incorrecte
      if ((h >= N)||(h < 0)||(tt.n == 0)) {
          return;
      } else if (tt.t[h].every == 0) {
          return;
      }

      tt.t[h].every = 0;
      tt.n--;

      if (tt.n == 0) {

          // Deshabilitar interrupció(CTC)
          TIMSK1 = 0b00000010;
      }
  }
}

void timer_cancel_all(void)
/*Cancel·la totes les accions planificades del servei.*/
{
  // Deshabilitar interrupció(CTC)
  TIMSK1 = 0b00000010;

  // Inicialització de les tasks table(tt) amb entries buides
  for (uint8_t i = 0; i < N; i++) {
      tt.t[i].every = 0;
  }
  // 0 entries
  tt.n = 0;

  return;
}

ISR(TIMER1_COMPA_vect)
{
    for (uint8_t i = 0; i < N; i++) {
        if (tt.t[i].every != 0) {
            tt.t[i].remaining--;

            if (tt.t[i].remaining == 0) {
                tt.t[i].callback();

                if (tt.t[i].ntimes == 1) {
                    tt.t[i].every = 0;

                    if (tt.n > 0) {
                        tt.n--;
                    }
                    continue;

                } else if (tt.t[i].ntimes > 1) {
                    tt.t[i].ntimes--;

                }
                tt.t[i].remaining = tt.t[i].every;

            }
        }
    }

    // Deshabilitar interrupcions
    if (tt.n == 0) {
        TIMSK1 = 0b00000010;
    }
}
