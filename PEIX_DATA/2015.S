/* exercici 1*/

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

__vector_18:


	cpi r16,'A'
	breq apagar
	cpi r16,'S'
	breq encendre
	cpi r16,'T'
	breq commuta


apagar:
	ldi r17,0
	call apaga
	ret

encendre:
	ldi r17,1
	call genera
	ret

commuta:
	ldi r17,2
	call compara
	ret


compara:
	in r20,PORTD_o
	cpi r20, 


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
	ldi r17,0



	/* Led */
	ldi r25, 0xFF
	OUT DDRB_o,r25

loop:
	cpi r17,0
	breq estat0
	cpi r17,1
	breq estat1
	cpi r17,2
	breq estat2
	rjmp loop
	ret