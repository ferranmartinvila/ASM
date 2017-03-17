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
.global __vector_18

__vector_18:
	lds r16,UDR0
	call tx
	cpi r19,1
	breq E1
	cpi r19,2
	breq E2
	reti
	E1:
		cpi r16,'S'
		breq estat2
		cpi r16,'T'
		breq estat2
		reti
	E2:
		cpi r16,'A'
		breq estat1
		cpi r16,'T'
		breq estat1
		reti

	estat1:
		ldi r19,1
		reti

	estat2:
		ldi r19,2
		reti


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
	/* set baud rate a 9600*/
	ldi	r16, 0
	sts	UBRR0H,r16
	ldi	r16, 103
	sts	UBRR0L,r16

	/* set frame format */
	/* el valor de reset ja és correcte:
	asíncron, sense paritat, 1 stop, 8 dades,
	velocitat normal, cominicació no multiprocessor */
	/*arreglem el bit U2X0 forçant el valor de reset
	al reglistre UCSR0A*/
	ldi	r16, 0b10100000
	sts	UCSR0A, r16
	
	/* enable rx, tx, amb interrpció de rx */
	ldi r16, 0b10011000
	sts	UCSR0B,r16

	/*habilitem interrupcions */
	sei
	sbi DDRB_o,5 /* PORT LED DE SORTIDA */

	/* INICIALITZEM MAQUINA ESTATS r19 */

	ldi r19,1


loop:
cpi r19,1
breq apaga
cpi r19,2
breq encen
rjmp loop

apaga:
	cbi PORTB_o,5
	rjmp loop
encen:
	sbi PORTB_o,5
	rjmp loop



