

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
;	    Controlaria el DDRB que es lestat del portD i per tant quan el vulgues encendre el posaria a 1 la pota 6
;	   	i sino el posaria a 0.
; 
;		La subrutina genera seria fer un sbi DDRB, X(bit de la posicio 6) i per tant activaria com a sortida el
;		to de loscilador.
;
;		La subrutina apaga seria fer un cbi DDRB, X(bit de la posicio 6) i per tant desactivaria la sortida per a
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

/* MAQUINA DESTATS */

__vector_18:	push r16
				push r17
				ldi  r17, 0
				lds  r16, UDR0
				call tx
				cpi  r16, 'S'
				breq on
				cpi  r16, 'A'
				breq off
				cpi  r16, 'T'
				breq comprovar

	on:			call genera
				ldi  r17, 1
				reti

	off:		call apaga
				ldi  r17, 0
				reti

	comprovar:	cpi  r17, 0
				breq on
				rjmp off

;=============================================================================================

;2. Sobre el registre destat de la CPU de lAVR respon a les seguents preguntes:
;
;	a) Suposant que r16 = 136 i r17 = 156 i despres de la instruccio ADD r16, r17. Quins flags
;      es veuran afectats per aquesta instruccio i quin sera el seu valor?
;
;			136			1   0   0   0   1   0   0   0
;		+	156         1   0   0   1   1   1   0   0
;       ----------------------------------------------
;		ADD 292		1 	0   0   1   0   0   1   0   0	
;			
;			SREG  		I 	T 	H	S 	V 	N 	Z 	C
;						0   0	1	0	0	0	0	1
;   
;   b) Suposant que r16 = 136 i r17 = 156 i despres de la instruccio SUB r16, r17. Quins flags
;	   es veuran afectats per aquesta instruccio i quin sera el seu valor?
;
;			136			1   0   0   0   1   0   0   0
;		-	156         1   0   0   1   1   1   0   0
;       ----------------------------------------------
;		SUB -20			1 	1 	1 	0   1   1   0   0	
;
;			SREG  		I 	T 	H	S 	V 	N 	Z 	C
;						0   0	0	1	0	1	0	0
;
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
;
;	   .macro val2dec
;		push r17
;		ldi r17, 0x30
;		add r16, r17
;		pop r17
;	   .endm
; 
;	b) Dissenya la subrutina print de manera transparent. Si consideres oportu, es pot utilitzar la 
;	   macro val2dec.

	print:	push r28
			push r29
			push r16
			push r17
			in r28, 0x3D
			in r29, 0x3E
			lds r17, Y
			lds r16, Y+1
			call tx
			mov r16, r17
			call tx
			pop r17
			pop r16
			pop r29
			pop r28
			ret

;	c) Dissenya de manera transparent la subrutina div10.

	div10:	push r20
			push r20
			push r20

			push r28
			push r29

			ldi r20, 10

			push r17
			push r16

			in r28, 0x3D
			in r29, 0x3E
			lds r16, Y
			cpi r16, 10
			brlo dividit
		x1:	subi r16, 10
			inc r17 
			cpi r16, 10
			brsh x1
	dividit:std Y+7, r17
			std Y+6, r16
			pop r16
			pop r17
			pop r20
			pop r29
			pop r28
			pop r17
			pop r16
			pop r20	
			ret

;======================================================================================================
;
;4. Aprofitant div10, dissenya la subrutina div10pila on el pas de parametres i resultat es fa a traves
;   de la pila. Dibuixa com queda el bloc dactivacio quan es crida a aquesta subrutina

    		r16		Calculador del residu
    		r17		Comptador per al quocient
    		r29		Proteccio r29 per al punter H
    		r28		Proteccio r28 per al punter L
    		r20     Resultat quocient
    		r20		Resultat residu
    		r20     Proteccio r20
    		call	adreça subrutina div10 H
    		call	adreça subrutina div10 L

;====================================================================================================

;5.	Aqui teniu lestructura dun programa. Suposeu que disposeu de les subrutines rx i tx utilitzades a 
;	les practiques. Suposeu que pel port serie sesta rebent un 3. Considereu que tant tx com rx tenen per 
;	parametre el registre r16.

1	.global main
2	
3	main:	call rx
4		push r16
5		call txr
6		pop r16
7		ret
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

;	a) Indica la sequencia dexecucio daquest programa en forma de llista en funcio del numero de la linia
;						 |r16 = 2			 |r16=1				 |r16=0				    |fi0  |fi1  |fi2  |fi3
;		3,4,5,9,10,11,12,14,15,16,9,10,11,12,14,15,16,9,10,11,12,14,15,16,9,10,11,12,13,19,18,19,18,19,18,19,6,7
;	
;
;	b) Podem considerar les subrutines tx i rx com una ampliacio del conjunt dinstruccions de la CPU,
;	   considerant que tardaran mes clocks que les instruccions originals? Si comparem la pila just abans
;	   de fer un call tx o call rx i just despres daquest call, la pila queda exactament igual? Justifica la resposta.
;
;
;	c) Dibuixeu levolucio que tindra la pila fent referencia a lapartat a). Per simplificar considereu que call tx i call 
;	   rx no afecten a la pila.
;			
;	   0.---  1.r16  2.call txr H  3.r16         4.r16		   5.r16			6.r16		  7.r16			8.call txr H  9.r16  10. ---
;					   call txr L    call txr H    r16			 r16			  r16			call txr H    call txr L
;					   r16           call txr L    call txr H    r16			  call txr H    call txr L    r16
;               	                 r16           call txr L    call txr H       call txr L    r16
;						   						   r16           call txr L       r16
;													    		 r16
;	d) Existeix algun bucle en aquest codi? Es fa alguna accio repetitiva en funcio del valor rebut pel port serie (call rx)?
;	   Justifica.
;
;	   -Si una funcio recursiva es considera un bucle, aleshores sí. Sino no. Es realitza una accio repetitiva fins que r16 val 0.
;   
;	e) Es pot considerar que hi ha recursivitat en aquest codi? Justifica la resposta.
;
;	   -Sí. Ja que fem un call a una etiqueta que ve ja dun call i es realitza a mes una mena de bucle que va omplint la pila.
;
;	f) Proposa un altre codi diferent que faci el mateix, pero amb una estructura totalment diferent.
;
;===================================================================================================================================	   