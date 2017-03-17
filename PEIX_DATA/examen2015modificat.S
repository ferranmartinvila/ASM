========================================================================================================
											EXAMEN Parcial 2015
========================================================================================================
1.  Considereu el seguent programa
--------------------------------------------------------------------------------------------------------


.global main
.global __vector_18
.global __do_copy_data
.global __do_clear_bss
/*Declaració de la taula a la pila*/
.section .data;Modifiquem la secció data
patro:	.byte 'L' ;Carregam a la primera posisció de la pila una 'L'
		.byte 'E';Carregam a la segona posisció de la pila una 'L'
		.byte 'D';Carregam a la tercera posisció de la pila una 'L'
patrof:;Carregam a la darrera posició de la pila un valor nul
N=patrof-patro ;Miram la llargada de la pila: 3-0=3

.section .bss
finstr:	.fill 3,1,0;r,s,v ficam 3 vegades el 0 amb 1 byte en hexa
finstrf:

.section .text;modifiquem la secció test
tx:		lds 	r17,UCSR0A;carragam al registre el valor d'r17 i la posem al port serie
		sbrs	r17,5;mirem si el bit 5 està a 1 si ho està saltam 1 posició sinó seguim el bucle(mira si es pot transmetre)
		rjmp	tx;feim bucle si no es compleix la condició
		sts		UDR0,r16;Guardem el que arriba pel port serie en el registre 16
		ret

cap:	push r16;Guardem el valor d'r16
		in r16, SREG;Guardem al r16 el valor de SREG
		push r16;Guardem a la pila el valor d'SREG;
		cpi r26, lo8(finstr+N);NO ES SEGUR. Collim la adreça que hi ha en el darrer valor de la pila i el comparem amb la del vector X
		breq vcap;si son igual saltam a vcap
		rjmp fcap;si són diferents saltam a fcap
vcap:	ldi r27, hi8(finstr);carreguem en el registre 27(2n part del vector X) la primer a adreça de la primera part de la pila
		ldi r26, lo8(finstr);carreguem la part d'abaix de la darrera adreça de la posició de la pila
fcap:	pop r16;carreguem el valor del SREG en el registre 16
		out SREG, r16;Treiem el valor al SREG que està en el registre 16
		pop r16;Treiem el valor de r16
		ret

cua:	push r16;guardem el valor de r16
		in r16, SREG;Carreguem el valor de SREG en el r16
		push r16;Guardem SREG
		cpi r26, lo8(finstr);Comparem si esta en el mateix adreça que la darrera
		breq vcua;Si es així saltam a vcua
		rjmp fcua;Si no es així saltam a fcua
vcua:	ldi r27, hi8(finstr+N);Guardem la darrera adreça de la pila(part baixa vector X)
		ldi r26, lo8(finstr+N);Guardem la darrera adreça de la pila (part baixa vector X)
fcua:	pop r16
		out SREG, r16
		pop r16
		ret

corre1:	ldi r29, hi8(finstr+N);Carreguem al vector X la primera part de la darrera adreça de la pila
		ldi r26, lo8(finstr+N);Carreguem al vector X la segona part de la darrera adreça de la pila
		clc;Netejam el carry
		clt;Posam a 1 el carry

		call cua;cridem a la subrutina cua
		ld r3, -X;Feim un post increment del vector X
		ld r4, -Y;Feim un post increment del vector Y
		sbc r3, r4
		breq corr1
		ret
/*Fa el mateix que la corre1 degut a la subrutina cua*/
corr1:	call cua
		ld r3, -X
		ld r4, -Y
		sbc r3, r4
		breq corr2
		set

corr2:	call cua
		ld r3, -X
		ld r4, -Y
		sbc r3, r4
		breq corr3
		set

corr3:	brtc on
off:	call ledoff
		ret
on:		call ledon
		ret

__vector_18:
		lds r16, UDR0
		call tx
		st X+, r16
		call cap
		call corre1
		reti

main:	call config_serial
		call config_led

		ldi r27, hi8(finstr)
		ldi r27, lo8(finstr)

		call ledoff
		sei

loop:	rjmp loop
		ret


--------------------------------------------------------------------------------------------------------
a)  Nombra i delimita en funcio dels numeros de linia les subrutines que existeixen:

--------------------------------------------------------------------------------------------------------
b)  Sabent que el led es troba al PORT B bit 5. Defineix les subrutines ledon, ledoff i config_led.
	Les subrutines han de ser transparents i nomes afectar al led de l arduino:

--------------------------------------------------------------------------------------------------------
c)  Transforma la rutina tx en transparent:

--------------------------------------------------------------------------------------------------------
d)  Transforma la rutina tx en una macro:

--------------------------------------------------------------------------------------------------------
e)  Transforma la rutina tx en una macro:







2.  Cert o fals
--------------------------------------------------------------------------------------------------------

a)  Per a que una etiqueta sigui el nom d una subrutina sempre ha d haver un CALL a aquesta etiqueta excepte
	per les rutines d interrupcio:

		Falsa perque podriem fer servir un rcall en comptes dun call.
		A mes sera una subrutina quan hi ha un ret
--------------------------------------------------------------------------------------------------------

b)	la instruccio LDS 5,95 carrega al registre 5 el valor del registre d estat

		Falsa perque no es l adreça correcte
--------------------------------------------------------------------------------------------------------

c)	SUB r3, r4 on r3=r4 te com a resultat C=0

		Certa perque l instruccio SUB de manera automatica nega el carry
--------------------------------------------------------------------------------------------------------

d)	El valor de l apuntador de la pila es decrementa en 2 despres de la instruccio reti

		Certa perque el stack pointer fa un preincrement de 2 per guardar el valor de l stackpointer
--------------------------------------------------------------------------------------------------------

e)	la instruccio ADD actua sobre els flags: H, S, V, N, Z, C

		Certa, ja que el flag i el T no es veuren afectats
