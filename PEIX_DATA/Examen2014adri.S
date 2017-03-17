
========================================================================================================
											EXAMEN FINAL 2014
========================================================================================================
1.  Dissenya un programa en assemblador que commuti lestat del led cada vegada que rep pel port serie
    la sequencia "LED". Si en qualsevol moment es rep un "espai", sha de transmetre pel port serie una
	"O" si el led està encès o una "X" si està apagat. l espai no interfereix en la seqüència de lletres
	que es vagi introduint. La recepcio per port serie es fa per interrupcio(__vector_18). Es disposa de
	les	seguents subrutines per facilitar la feina: setup_serie(configura el port serie per interrupcio),
	tx (transmet pel port serie el contingut del registre 16). Es recorda que el led es troba al bit 5 del
	Port B de lAVR i que escriure un "1" en el registre PIN commuta el valor del registre PORT.
--------------------------------------------------------------------------------------------------------
a)  Defineix les macros:
			- init_led   (inicialitza i configura lAVR per fer servir el led i deixarho apagat)
			- led_on     (encen el led)
			- led_off    (apaga el led)
			- get_led    (torna al bit T el valor de lestat del led)
			- toggle_led (commuta lestat del led)
	Sha de tenir en compte que han de ser transparents.
--------------------------------------------------------------------------------------------------------

.macro init_led
	sbi DDRB_o,5 /* S de sbi perquè el port b serà sortida */
	cbi PORTB_o,5 /*  */
.endm

.macro led_on
	sbi PORTB_o,5
.endm

.macro led_off
	cbi PORTB_o,5
.endm

.macro get_led
	push r17
	IN r17,PORTB_o
	bst r17,5
	pop r17
.endm

.macro toggle_led
	sbi PINB, 5
.endm

/*  MALAMENT toogle_led
	SBIS PORTB_o,5	/* skip seguent linia si està a 1 */
	SBI PORTB_o,5
	CBI PORTB_o,5
 */


------------------------------------------------------------------------------------------------------
b) 	Justifica si es millor que les definicions de a) siguin macros o subrutines.
	Una macro amb parametres es el mateix que una subrutina amb parametres.
------------------------------------------------------------------------------------------------------
	/* 	Es millor que siguin subrutines si es criden moltes vegades, en canvi si nomes la cridem
		una vegada seran millor les macros.

		A nivell funcional sí, a nivell de codi no. */

------------------------------------------------------------------------------------------------------
c)	Descriu com funciona la interrupcio de transmissio pel port serie.
------------------------------------------------------------------------------------------------------

	/*Cada cop que el bit 6 de l UCSR0A està a 1 es crida el vector 19  */

------------------------------------------------------------------------------------------------------
d)  Dibuixa el graf de la maquina destats corresponen a aquest programa.
------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------
e)  Presenta el codi font del programa complert, definint les constants necessaries i
	utilitzant les macros de a) sempre que es pugui.
------------------------------------------------------------------------------------------------------

.set PINB,0x03
.set DDRB_o,0x4
.set PORTB_o,0x5
.global main
.global __vector_18

__vector_18:
	lds r16,UDR0
	/*call tx*/
	cpi r16," "
	breq espai
	cpi r20,1
	breq E1
	cpi r20,2
	breq E2
	cpi	r20,3
	breq E3
	cpi r20,4
	breq E4
	reti

	E1:
		cpi r16,'L'
		breq estat2
		cpi r16,'L'
		brne estat1
	E2:
		cpi r16,'E'
		breq estat3
		cpi r16,'L'
		breq estat2
		cpi r16,'E'
		brne estat1
	E3:
		cpi r167,'D'
		breq estat4
		cpi r16,'L'
		breq estat2
		cpi r167,'D'
		brne estat1
	E4:
		cpi r16,'L'
		breq estat2
		cpi r16,'L'
		brne estat1

	estat1:
		ldi r20,1
		reti
	estat2:
		ldi r20,2
		reti
	estat3:
		ldi r20,3
		reti
	estat4:
		ldi r20,4
		reti

	espai:
		get_led
		bld r17,0
		cpi r17,1
		breq escriuO
		cpir17,0
		breq escriuX
		reti
	escriuO:

	escriuX:
main:
	init_led
	ldi r20,0

loop:
cpi r20,4
breq canvi
rjmp loop

canvi:
	toogle_led
ret

/*
apaga:
	cbi PORTB_o,5
	rjmp loop
*/

======================================================================================================
2.  Dissenya una subrutina suma_parells a la que se li passa com a parametre, a traves de
	registre, ladresa duna taula i realitza la suma dels 100 primers valors parells. Considereu
	que el primer valor de la taula correspon a la posicio 0. El resultat de la suma sha de
	retornar a traves dels registres r1:r0. Aquesta subrutina ha de ser transparent.
------------------------------------------------------------------------------------------------------
a)	Definiu previament una subrutina suma que sumi amb precisio de 2 bytes els words r1:r0 i
	r3:r2 i retorni el resultat a r1:r0. Aquesta subrutina ha de ser transparent.
------------------------------------------------------------------------------------------------------
	SREG=0x3F
	suma:
		push r20
		lds r20,SREG /* S HA DE FER AMB UN IN (NO ES POT AMB LDS)*/
		push r20
		add r0,r2
		adc r1,r3
		pop r20
		st SREG,r20
		pop r20
		ret

------------------------------------------------------------------------------------------------------
b)  Que sha de fer amb cadascun dels flags del registre destat de la CPU perque tots indiquin el
	valor correcte despres dhaver cridat a la subrutina suma?
------------------------------------------------------------------------------------------------------
	fer la rutina en una de manera transparent en una pila.


------------------------------------------------------------------------------------------------------
c)	Escriu el codi font de la subrutina complerta.
------------------------------------------------------------------------------------------------------
	SREG=0x3F
	ldi r21,100
	suma_parells:
		ldi r26, lo8(taulac1)
		ldi r27, hi8(taulac1)
		cpi r21,0
		breq fi
		ld r16, X+
		mov r20,r16
		andi r20,0b0000001
		cpi r20,1
		breq suma_parells
		mov r2,r16
		rjmp suma
		dec r21

		ret

	suma:
		push r20
		lds r20,SREG
		push r20
		add r0,r2
		adc r1,r3
		pop r20
		st SREG,r20
		pop r20
		rjmp suma_parells
fi:
    ret

------------------------------------------------------------------------------------------------------
d)	Aprofitant la subrutina suma_parells, crea una subrutina suma_parells_pila on el pas de
	parametres i de resultats es fa a traves de la pila. Indica que cal fer abans i despres de la
	crida a aquesta subrutina. Dibuixa com queda la pila (bloc dactivacio) amb aquesta subrutina.
------------------------------------------------------------------------------------------------------

	SREG=0x3F
	suma:
		push r20
		lds r20,SREG
		push r20
		add r0,r2
		adc r1,r3
		pop r20
		st SREG,r20
		pop r20
		ret
