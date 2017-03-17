

;===================================EXAMEN FINAL 2015==============================================

;1. Disseny dun programa en assemblador que commuta lestat dun oscil·lador implementat amb el Timer
;   0 de manera que quan rep del port serie la lletra 'S' soni el to, quan rebi la lletra 'A' apagui
;   el to i quan rebi la lletra 'T' commuti lestat de loscil·lador
;
;   - La recepcio pel port serie es amb interrupcio. (__vector_18)
;   - Tenim:
;			- setup_serie (configura el port serie per interrupcio)
;			- tx (transmet pel port serie el contingut del registre r16)
;			- setup_timer (configura el timer 0 per generar un to)
;			- genera (genera un to consistent en un senyal quadrat a la pota 6 del Port D)
;			- apaga (mante la pota 6 del port D a un valor constant i per tant no es genera cap to)
;
;   a) Descriu de quina manera controlaries que la pota de sortida de loscil·lador generi el to o be
;      quedi sense oscil·lar. Descriu qualitativament com dissenyaries les subrutines genera i apaga.
;
;	    Controlaria el DDRD que es lestat del portD i per tant quan el vulgues encendre el posaria a 1 la pota 6
;	   	i sino el posaria a 0.
;
;		La subrutina genera seria fer un sbi DDRD, X(bit de la posicio 6) i per tant activaria com a sortida el
;		to de loscilador.
;
;		La subrutina apaga seria fer un cbi DDRD, X(bit de la posicio 6) i per tant desactivaria la sortida per a
;		que no pogues generar cap to.
;
;   b) Dibuixa el graf de la maquina destats corresponent a aquest programa.
;
;		-------					-------
;		|  S  |		A o T 		|  A  |
;		----ENCES ---------> APAGAT----
;				  <---------
;					S o T
;
;   c) Presenta el codi font del programa complert aprofitant les subrutines donades.


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

;=============================================================================================

;2. Sobre el registre destat de la CPU de lAVR respon a les seguents preguntes:
;
;	a) Suposant que r16 = 136 i r17 = 156 i despres de la instruccio ADD r16, r17. Quins flags
;      es veuran afectats per aquesta instruccio i quin sera el seu valor?
;
;			136			1   0   0   0   1   0   0   0
;		+	156      1   0   0   1   1   1   0   0
;       ----------------------------------------------
;		ADD 292		1 	0   0   1   0   0   1   0   0
;
;			SREG 	I 	T 	H 	S 	V 	N 	Z 	C
;						0  0	 1	 0	 0	 0	 0	 1
;
;   b) Suposant que r16 = 136 i r17 = 156 i despres de la instruccio SUB r16, r17. Quins flags
;	   es veuran afectats per aquesta instruccio i quin sera el seu valor?
;
;			136			1   0   0   0   1   0   0   0
;		-	156     1   0   0   1   1   1   0   0
;    complement A2 de 156 -> 0 1 1 0 0 1 0 0
;			----------------------------------------------
;		SUB -20		1 	1 	1 	0   1   1   0   0
;
;			SREG  I 	T 	H 	S 	V 	N 	Z 	C
;						0   0  	0	  1   0 	1 	0	  0
;
;====================================================================================================



/* EXERCICI 3*/
;====================================================================================================
;
;3. La subrutina print te com a parametre el registre r16 i treu pel port serie la representacio
;	decimal del valor que se li passa com a parametre. Disposes de les subrutines tx i de la
;	subrutina div10. La subrutina div10 te com a parametre el registre r16. Aquesta subrutina retorna
;   a r16 el quocient de la divisio per 10 i a r17 el residu daquesta divisio.
;
;	a) Dissenya una macro val2dec que actui sobre el registre r16 transformant el seu valor numeric
;	   (en el marge 0:9) en la seva representacio amb caracter ASCII. Recorda que el caracter ASCII
;	   corresponent al '0' es el 0x30.

	   .macro val2dec
;		push r19
;		ldi r19, 0x30
;		add r16, r19
;		call tx
;		pop r19
;	   .endm

/*b)*/

print:
	cpi r16,100
	brsh divgran
	call div10
	val2dec
	mov r16, r17
	val2dec


divgran:
	call div10
	cp r16, 10
	brsh divisio
	val2dec
	mov r16, r17
	val2dec
	mov r16, r18
	val2dec
	ret

divisio:
	call div10
	mov r18, r17
	rjmp divgran



/*c)*/

ldi r20, 10
ldi r21, 0
div10:
	push r20
	push r21
	cpi r16,10
	brsh resta
	mov r17, r16
	mov r16, r21
	call tx
	mov r16, r17
	call tx
	pop r21
	pop r20
	ret



resta:
	inc r21
	sub r16, r20
	rjmp div10



/* Exercici 4 */

	push r18
	push r17
	push r21
	push r20


/* Exercici 5*/

;5.	Aqui teniu lestructura dun programa. Suposeu que disposeu de les subrutines rx i tx utilitzades a
;	les practiques. Suposeu que pel port serie sesta rebent un 3. Considereu que tant tx com rx tenen per
;	parametre el registre r16.

1	.global main
2
3	main:	call rx
4			push r16
5			call txr
6			pop r16
7			ret
8
9	txr:	in r28, SPL
10			in r29, SPH
11			ldd r16, Y+3
12			tst r16
13			breq fi
14			dec r16
15			push r16
16			call tx
17			call txr
18			pop r16
19		fi:	ret






/*a) Indica la sequencia dexecucio daquest programa en forma de llista en funcio del numero de la linia */

	1-3-4-5-9-10-11-12-14-15-16-17-9-10-11-12-14-15-16-17--9-10-11-12-14-15-16-17-9-10-11-12-13-19-18-19-18-19-18-19-6-7

/* 	b) Podem considerar les subrutines tx i rx com una ampliacio del conjunt dinstruccions de la CPU,
	   considerant que tardaran mes clocks que les instruccions originals? Si comparem la pila just abans
	   de fer un call tx o call rx i just despres daquest call, la pila queda exactament igual? Justifica la resposta.
*/

	augmenta dues posicions a la memòria de la pila cada vegada que fem un call ABANS DE QUE HI HAGI EL RET DEL TX O RX.
	si pensem en el moment que ja ha fet el ret l rx o el tx la pila queda exactament igual.


/*	c) Dibuixeu levolucio que tindra la pila fent referencia a lapartat a). Per simplificar considereu que call tx i call
	   rx no afecten a la pila. */

	   DONE

/* 	d) Existeix algun bucle en aquest codi? Es fa alguna accio repetitiva en funcio del valor rebut pel port serie
	(call rx)?
	   Justifica.
 */
/* 	NOPE. En funció del nombre que rebi per rx farà més cops l acció repetitiva de call txr i anar decrementant fins a 0.
*/
/* e) Es pot considerar que hi ha recursivitat en aquest codi? Justifica la resposta.*/

/*		SI. Ja que anem cridant txr dins de txr*/


/* f) Proposa un altre codi diferent que faci el mateix, pero amb una estructura totalment diferent.*/


	/*
main:
	call rx

loop:
	tst r16
	breq fi
	dec r16
	call tx
	rjmp loop

fi:
	ret
	*/
