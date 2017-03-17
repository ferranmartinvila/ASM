
========================================================================================================
											EXAMEN FINAL 2014
========================================================================================================
1.  Dissenya un programa en assemblador que commuti lestat del led cada vegada que rep pel port serie 
    la sequencia "LED". Si en qualsevol moment es rep un "espai", sha de transmetre pel port serie una
	"O" introduint. La recepcio per port serie es fa per interrupcio(__vector_18). Es disposa de les 
	seguents subrutines per facilitar la feina: setup_serie(configura el port serie per interrupcio), tx
	(transmet pel port serie el contingut del registre 16). Es recorda que el led es troba al bit 5 del 
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
	cbi PORTB, 5
	sbi DDRB,  5
.endm

.macro led_on
	sbi PORTB, 5
.endm

.macro led_off
	cbi PORTB, 5
.endm

.macro get_led
	bst PORTB, 5
.endm

.macro toggle_led
	lds PIN, 1
.endm

------------------------------------------------------------------------------------------------------
b) 	Justifica si es millor que les definicions de a) siguin macros o subrutines.	
	Una macro amb parametres es el mateix que una subrutina amb parametres.
------------------------------------------------------------------------------------------------------
		
		Es millor que siguin subrutines si es criden moltes vegades, en canvi si nomes la cridem
		una vegada seran millor les macros.

		A nivell funcional sí, a nivell de codi no. 
------------------------------------------------------------------------------------------------------		
c)	Descriu com funciona la interrupcio de transmissio pel port serie.
------------------------------------------------------------------------------------------------------

		En el moment que lUDR0 

------------------------------------------------------------------------------------------------------
d)  Dibuixa el graf de la maquina destats corresponen a aquest programa.
------------------------------------------------------------------------------------------------------

				  
		ENCES --------> APAGAT

------------------------------------------------------------------------------------------------------
e)  Presenta el codi font del programa complert, definint les constants necessaries i 
	utilitzant les macros de a) sempre que es pugui.
------------------------------------------------------------------------------------------------------

======================================================================================================
2.  Dissenya una subrutina suma_parells a la que se li passa com a parametre, a traves de 
	registre, ladresa duna taula i realitza la suma dels 100 primers valors parells. Considereu
	que el primer valor de la taula correspon a la posicio 0. El resultat de la suma sha de 
	retornar a traves dels registres r1:r0. Aquesta subrutina ha de ser transparent.
------------------------------------------------------------------------------------------------------
a)	Definiu previament una subrutina suma que sumi amb precisio de 2 bytes els words r1:r0 i 
	r3:r2 i retorni el resultat a r1:r0. Aquesta subrutina ha de ser transparent.
------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
b)  Que sha de fer amb cadascun dels flags del registre destat de la CPU perque tots indiquin el
	valor correcte despres dhaver cridat a la subrutina suma?
------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
c)	Escriu el codi font de la subrutina complerta.
------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
d)	Aprofitant la subrutina suma_parells, crea una subrutina suma_parells_pila on el pas de 
	parametres i de resultats es fa a traves de la pila. Indica que cal fer abans i despres de la 
	crida a aquesta subrutina. Dibuixa com queda la pila (bloc dactivacio) amb aquesta subrutina.
------------------------------------------------------------------------------------------------------

======================================================================================================
3.	Dissenya una subrutina canvia_pila de manera que el valor que se li passa com a parametre a 
	traves de la pila el substitueixi pel valor que hi ha a la variable var situada en una posicio
	de memoria de dades i retorni el valor corresponent al que hi havia originalment a var. La 
	subrutina ha de ser transperent. Indica que cal fer abans i despres de la crida a aquesta
	subrutina. Dibuixa com queda la pila (bloc dactivacio) amb aquesta subrutina.
------------------------------------------------------------------------------------------------------

VAR = ...
SPL = 0x3D
SPH = 0x3E

				push r28
				push r29
				push r26
				push r27
				push r20
				push r16
				call rx
				push r16
				
				lds r26, lo8(var)
				lds r27, hi8(var)
				ld r16, X
				
				in r28, SPL
				in r29, SPH
				ld r20, Y

				st Y, r16
				st X, r20

===================================================================================================
4. Aqui teniu lestructura dun programa.
---------------------------------------

0	.global main
1	.section .text

2	.macro retco
3			pop r31
4			pop r30
5			icall
6	.endm

7	main:
8			/* inicialitzacio del proces 1 */
9			call main2
10 	bucle1:
11				retco
12				/* proces 1 */
13				rjmp bucle1
14				ret
	
15	main2:
16			/* inicialitzacio del proces 2 */
17	bucle2:
18			retco
19			/* proces 2 */
20			rjmp bucle2
21			ret

--------------------------------------------------------------------------------------------------
a)	Descriu que li passa a la pila i al comptador de programa quan sexecuta la macro retco
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
b)	Elimina i substitueix tot el que processi lassemblador deixant estrictament les 
	instruccions que executara la CPU de lAVR i torna a numerar les linies. Considera els 
	comentaris com a blocs de codi del programa.
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
c)	Indica la sequencia dexecucio del programa en forma de llista dinstruccions de cpu. 
	Considera els comentaris com a blocs de codi del programa. Indica el contingut de la 
	pila despres de cada instruccio. Indica en quin moment es produeix una sequencia de 
	repeticio en lexecucio.
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
d)	Quantes rutines existeixen en aquest programa? Emmarca en un quadrat cadascuna de les
	rutines. Es pot considerar el programa principal com una rutina?
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
e)	Sexecuta en algun moment algun dels ret que apareixen en el codi? Hi ha algun error en
	el codi?
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
f)	Es pot considerar que aquest esquema correspon a una estructura dexecucio de 2 processos 
	en paral·lel? Justifica la resposta aportant pros i contres.
--------------------------------------------------------------------------------------------------





