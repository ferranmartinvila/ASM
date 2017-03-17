SBI P,b --> canvia bit b de port P a 1
CBI P,b --> canvia bit b de port P a 0

EOR R,r --> EOR 5, registre

EORI R,K --> EORI 5, 0b00100000 (OR exclusive inmediate)/no existeix aquesta instrucció
Ho fem així:
LDI 16, 0b00100000 (LDI de 0-15 no es pot degut a la instrucció)
EOR 5,6
OUT 5,5

LDI 16, 0b00100000
OR 3,16

NEG R -->
COM R -->

IN 5,5 (Passar el contingut de un registre a un altre)
