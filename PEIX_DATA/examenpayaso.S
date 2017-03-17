.set DDRB_o,0x4
.equ PORTB_o,0x5 
PORTD_o = 0x0b
DDRD_o = 0x0a
UDR0 = 0xc6
UBRR0H = 0xc5
UBRR0L = 0xc4
UCSR0C = 0xC2
UCSR0B = 0xC1
UCSR0A = 0xC0
SPL = 0x3D
SPH = 0x3E

.global main

rx: lds r16, UCSR0A
	sbrs r16,7
	rjmp rx
	lds r16, UDR0
	ret

tx:	lds r17, UCSR0A
	sbrs r17,5
	rjmp tx
	sts UDR0,r16
	ret

main:
	ldi r20,1
	/*Configuració pins*/
	ldi r16,0
	sts UBRR0H,r16
	ldi r16,103
	sts UBRR0L,r16
	ldi r16,0b00100000
	sts UCSR0A,r16
	ldi r16,0b00000110
	sts UCSR0C,r16
	ldi r16, 0b00011000
	sts UCSR0B,r16
	ldi r16,0b00000010
	out DDRD_o,r16
	/*Acabo configuracio*/
	/* Led */
	ldi r25, 0xFF
	OUT DDRB_o,r25

loop:
	nop
	rjmp loop
	ret




