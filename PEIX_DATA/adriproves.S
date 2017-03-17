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

prova:
	push r28
	push r29
	IN r28,SPL
	IN r29,SPH
	ldd r17,Y+5 /* baixem 5 posicions a la pila i agafem la A i copiem a r17*/
	mov r16,r17 
	call tx /*escribim a */
	ldi r25,'P' 
	std Y+4,r25 /* introduim el que hi ha a r25 4 posicions més avall (r16)*/
	ldd r20, Y+4 /* copiem el que hi ha al Y+4 a r20 */
	mov r16,r20
	call tx
	pop r29
	pop r28
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
	ldi r25, 0xFF /*fiquem tot 1 and port b */
	OUT DDRB_o,r25
	ldi r16,'A'
	push r16
	push r16
	call prova
	pop r16
	pop r16



ldi r26, lo8(text)
ldi r27, hi8(text)
pole:
	ld r16,X+
	call tx
	cpi r26,lo8(text_fin)
breq ok
rjmp pole

ok:
	cpi r27,hi8(text_fin)
	breq ok2
	rjmp pole

ok2:
	ret


	
loop:
nop
rjmp loop


.section .data

text: .ascii "hola"
text_fin:

.global__do_copy_data





/* 
METODES D ADREÇAMENT

a) Immediat:
	La dada que es vol emmagatzemar és a la instrucció:
		LDI r16, K

b) Directe:
	Hi ha les adreces on s ha d accedir (on hi ha la dada i a on va):
		MOV r16, r0
		ADD r16, r0
		INC r16
		LDS r16, 0x02AC -> Memòria de dades
		STS 0xAAA, r16  -> Memòria de dades

c) Indirecte:
	L adreça d origen és el valor que conté el registre donat:
		LD r16, X

d) Indexat:
	Adreça a un registre, s accedirà a aquesta adreça + I
		------------------------------
		|  OP   |  RD  |  Reg  |  I  |   LDD r16, Y+q
		------------------------------              |
		                           |                |
		                           ------------------

e) Base + índex (l AVR no en té):
	Mateix cas que l indexat, però l índex és dins d un registre
		MOV r4, (x+r20) --> on x és adreça base i r20 índex

f) Per pila (l AVR no en té)
	No es gasta ni un bit per adreça