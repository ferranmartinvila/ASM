#include "ether.h"
#include "queue.h"
#include "timer.h"
#include "modulator.h"
#include "mchar.h"
#include "mtbl.h"

#define DOT (100)
#define GAP (DOT)
#define DASH (3*DOT)
#define LETTERGAP (3*DOT)

queue_t morseQueue;
mchar_iter_t i;

static void wh(void);
static void sendChar(void);

static void envia_final(void)
{
    queue_dequeue(&morseQueue);

    if (!queue_is_empty(&morseQueue)) {
        sendChar();
    }
}

static void envia_silenci(void)
{
    modulator_set(false);
    timer_after(TIMER_MS(GAP), wh);
}

static void wh(void)
{
    if (mchar_valid(i)) {
        modulator_set(true);
        if (mchar_next(&i) == MDot) {
          timer_after(TIMER_MS(DOT), envia_silenci);
        } else {
          timer_after(TIMER_MS(DASH), envia_silenci);
        }
    } else {
        timer_after(TIMER_MS(LETTERGAP), envia_final);
    }
}

static void sendChar(void)
/* Autòmat que controla l'enviament de codi morse */
{
    i = mchar_iter(mtbl_a2m(queue_front(&morseQueue)));
    wh();
}

void ether_init(void)
/* Inicialitza el mòdul. Cal cridar-la abans d’usar el mòdul i amb
les interrupcions inhibides. Es pot cridar més d’una vegada i
s’obté el mateix efecte */
{
    //Inicialitzacions del timer
    timer_init();
    modulator_init();

    //Inicialització de queue
    queue_empty(&morseQueue);
}


void ether_put(uint8_t c)
/* Envia el caràcter c usant el canal Morse. c ha de contenir un
dels caràcters que admeten codificació Morse: els caràcters A–Z,
els dígits 0–9 i el caràcter espai. */
{
    bool empty = queue_is_empty(&morseQueue);
    if (!queue_is_full(&morseQueue)) {
        if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || (c == ' ')) {
            // Posa a la cua
            queue_enqueue(&morseQueue, c);

            // Envia caràcter
            if (empty) {
                sendChar();
            }
        }
    }
}
