.code

; SUM FUNCTION ------------------------
	sum proc
	
		add edx, ecx
		mov eax, edx
		ret

	sum endp
; -------------------------------------

; REST FUNCTION -----------------------
	rest proc
	
		sub ecx, edx
		mov eax, ecx
		ret

	rest endp
; -------------------------------------

; MULT FUNCTION -----------------------
	mult PROC
	
		imul ecx, edx ; multiply the signed operands
		mov eax, ecx ; put the answer to eax to return it
		ret

	mult ENDP
; -------------------------------------

; DIVIDE FUNCTION ---------------------
	divide PROC

		mov r8d , edx ; Now r8d is the divisor
		mov eax, ecx ; Now eax is the dividend 

		cdq ; convert to sign extended, fills edx with the sign bit of eax

		idiv r8d ; in idiv the answer is put in eax so
		; So this is like eax = eax / r8d

		ret

	divide ENDP
; -------------------------------------

; REM FUNCTION ------------------------
	rem PROC

	mov r8d , edx ; Now r8d is the divisor
	mov eax, ecx ; Now eax is the dividend 


	cdq ; convert to sign extended, fills edx with the sign bit of eax

	idiv r8d ; in idiv the answer is put in eax 
	mov eax,edx ; Chuck it into EAX to return
	ret

	rem ENDP
 ; -------------------------------------
 


end
