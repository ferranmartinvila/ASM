ether: ether.c queue.c timer.c modulator.c mchar.c mtbl.c
	avr-gcc -std=c99 -Os -mmcu=atmega328p -fshort-enums -DF_CPU=16000000UL test_ether.c mtbl.c ether.c queue.c timer.c modulator.c mchar.c -o test_ether
	avr-objcopy -Oihex test_ether test_ether.hex

timer: timer.c test_timer.c serial_device.c gpio_device.c queue.c
	avr-gcc -std=c99 -Os -mmcu=atmega328p -fshort-enums -DF_CPU=16000000UL timer.c test_timer.c serial_device.c gpio_device.c queue.c -o test_timer
	avr-objcopy -Oihex test_timer test_timer.hex

crossing: control.c crossing.c ether.c gpio_device.c lamp.c mchar.c modulator.c mtbl.c queue.c semaph.c serial_device.c timer.c blck_serial.c
	avr-gcc -std=c99 -Os -mmcu=atmega328p -fshort-enums -DF_CPU=16000000UL control.c crossing.c ether.c gpio_device.c lamp.c mchar.c modulator.c mtbl.c queue.c semaph.c serial_device.c timer.c blck_serial.c -o crossing
	avr-objcopy -Oihex crossing crossing.hex
