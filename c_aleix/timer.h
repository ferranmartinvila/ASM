#ifndef TIMER_H
#define TIMER_H
#include <stdint.h>
#include <stdbool.h>

#define FREQ_TICK 100 // 10ms
#define PRESCALER 8
#define N 20

#define OCR1A_valor ((uint16_t) (F_CPU/(PRESCALER*FREQ_TICK)-1))

#define TIMER_MS(ms) (ms/10)
/*TIMER MS() és una funció que converteix unitats de temps: de
milisegons a ticks. Cal recordar que un tick en aquest context
és la unitat mı́nima de temps amb que treballa aquest mòdul.*/

#define TIMER_ERR (timer_handler_t)-1
/*Constant de tipus timer handler t que indica un error en el
moment de planificar una nova funció.*/


typedef void (*timer_callback_t)(void);

typedef int8_t timer_handler_t;

void timer_init(void);

timer_handler_t timer_after(uint8_t ticks, timer_callback_t f);

timer_handler_t timer_every(uint8_t ticks, timer_callback_t f);

timer_handler_t timer_ntimes(uint8_t n, uint8_t ticks, timer_callback_t f);

void timer_cancel(timer_handler_t h);

void timer_cancel_all(void);

#endif
