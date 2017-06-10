#include "timer.h"
#include <util/delay.h>
#include "gpio_device.h"
#include "serial_device.h"
#include <avr/io.h>

static pin_t led, led2, led3;
static timer_handler_t h;
static uint8_t i = 4;

void sprint(char s[])
{
    uint8_t i = 0;
    while (s[i] != '\0') {
        serial_put(s[i]);
        i++;
    }
}

void toggle_led(void)
{
    pin_toggle(led);
}

void led_on(void)
{
    pin_w(led, true);
}

void led_off(void)
{
    pin_w(led, false);
}

void cancel_toggle_led(void)
{
    timer_cancel(h);
    pin_w(led, false);
}

void led2_off(void);
void led2_on(void);

void led2_off(void)
{
    pin_w(led2, false);
    timer_after(TIMER_MS(500), led2_on);
}

void led2_on(void)
{
    pin_w(led2, true);
    timer_after(TIMER_MS(500), led2_off);
}


void test_every(void)
{
    h = timer_every(TIMER_MS(100), toggle_led);
    _delay_ms(97.5);
    if (pin_r(led)) {
        sprint("Error. Every change so fast.\r\n");
    } else {
        sprint("OK.\r\n");
    }
    _delay_ms(15);
    if (!pin_r(led)) {
        sprint("Error. Every change so slow.\r\n");
    } else {
        sprint("OK.\r\n");
    }
    _delay_ms(5000);
    timer_cancel(h);
    pin_w(led, true);
}

void test_after(void)
{
    pin_w(led, false);
    timer_after(TIMER_MS(2500), led_on);
    _delay_ms(2487.5);
    if (pin_r(led)) {
        sprint("Error. After change so fast.\r\n");
    } else {
        sprint("OK.\r\n");
    }
    _delay_ms(15);
    if (!pin_r(led)) {
        sprint("Error. After change so slow.\r\n");
    } else {
        sprint("OK.\r\n");
    }
}

void test_ntimes(void)
{
    pin_w(led, false);
    timer_ntimes(3, TIMER_MS(1000), toggle_led);
    _delay_ms(986);
    if (pin_r(led)) {
        sprint("Error. Ntimes change so fast (1).\r\n");
    } else {
        sprint("OK.\r\n");
    }
    _delay_ms(15);
    if (!pin_r(led)) {
        sprint("Error. Ntimes change so slow (1).\r\n");
    } else {
        sprint("OK.\r\n");
    }
    _delay_ms(2000);
    if (pin_r(led)) {
        sprint("Error. Ntimes change so fast (2).\r\n");
    } else {
        sprint("OK.\r\n");
    }
    _delay_ms(15);
    if (!pin_r(led)) {
        sprint("Error. Ntimes change so slow (2).\r\n");
    } else {
        sprint("OK.\r\n");
    }
    _delay_ms(1500);
    if (!pin_r(led)) {
        sprint("Error. Ntimes still running.\r\n");
    } else {
        sprint("OK.\r\n");
    }
}

void test_more_than_one_task(void)
{
    h = timer_every(TIMER_MS(100), toggle_led);
    timer_after(TIMER_MS(500), led2_on);
    timer_after(TIMER_MS(2500), cancel_toggle_led);
    _delay_ms(4960);
    timer_cancel_all();
    _delay_ms(5000);
    pin_w(led2, false);
}


void main(void) {
    led = pin_bind(&PORTD, 7, Output);
    led2 = pin_bind(&PORTD, 6, Output);
    led3 = pin_bind(&PORTD, 5, Output);
    timer_init();
    serial_open();

    sprint("Initialized.\r\n");
    test_every();
    _delay_ms(1000);
    test_after();
    _delay_ms(1000);
    test_ntimes();
    _delay_ms(1000);
    test_more_than_one_task();

    for(;;);
}
