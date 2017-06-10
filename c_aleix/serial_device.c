#include <avr/io.h>
#include "serial_device.h"
#include "queue.h"
#include <avr/interrupt.h>

#define BAUD 9600

#include <util/setbaud.h>

queue_t RxQueue;
queue_t TxQueue;

void serial_open(void)
/*Inicialitza el modul i deixa la UART a punt per enviar/rebre
caracters de 8 bit a 9600 bit s −1 , amb 1 bit d’stop, sense paritat
i en mode ası́ncron.*/
{
    // Buido les cues de lectura i rececpió.
    queue_empty(&RxQueue);
    queue_empty(&TxQueue);

    // Configuro la USART
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;

    #if USE_2X
    UCSR0A |= _BV(U2X0);
    #else
    UCSR0A &= ~(_BV(U2X0));
    #endif

    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); /* 8-bit data */
    UCSR0B = _BV(RXCIE0) | _BV(RXEN0) | _BV(TXEN0);

    // Habilito les interrupcions
    sei();
}

void serial_close(void)
/* Deshabilita la UART per no rebre ni transmetre res. En cas que
quedin car`acters al buffer de sortida, s’espera fins que acabin de
sortir abans de deshabilitar la UART. */
{
    loop_until_bit_is_set(UCSR0A, UDRE0); /* Espera que es buidi el registre de dades */

    // Deshabilito les interrupcions.
    UCSR0B &= ~(_BV(RXCIE0) | _BV(RXEN0) | _BV(TXEN0));
}

uint8_t serial_get(void)
/*Retorna un byte llegit de la cua port sèrie. Es bloqueja indefinidament
fins que hi ha un caràcter disponible per a ser llegit. En cas que
no es llegeixi prou sovint es poden perdre caràcters.*/
{
    while(queue_is_empty(&RxQueue)); // Espera que hi hagi dades a la cua de recepció
    uint8_t read = queue_front(&RxQueue); // Llegeix una dada
    queue_dequeue(&RxQueue); // Elimina aquesta dada de la cua
    return read;

}

void serial_put(uint8_t c)
/*Envia un byte pel port sèrie. En cas que la cua de transmissó esitugui plena,
es bloqueja fins que es pugui afegir a la cua */
{
    while(queue_is_full(&TxQueue)); // Espera que hi hagi espai a la cua de transmissió
    queue_enqueue(&TxQueue, c);
    UCSR0B |= (_BV(UDRIE0));
}

bool serial_can_read(void)
/*Retorna true sii hi ha un caràcter disponible per a ser llegit. Si
aquesta funció retorna true es garanteix que una posterior crida
a serial_get() no es bloquejarà.*/
{
    return (!queue_is_empty(&RxQueue));
}

ISR(USART_RX_vect) {
    queue_enqueue(&RxQueue, UDR0);
}

ISR(USART_UDRE_vect) {
    if (!queue_is_empty(&TxQueue)) {
        UDR0 = queue_front(&TxQueue); // Envia una dada
        queue_dequeue(&TxQueue); // Elimina aquesta dada de la cua
    } else {
        UCSR0B &= ~(_BV(UDRIE0));
       }
}
