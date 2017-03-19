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

		idiv r8d ; in idiv the answer is put in eax & the remaind value is put in edx
		mov eax,edx ; Chuck it into EAX to return
		ret

	rem ENDP
 ; -------------------------------------
 
 ; CLEAN BUFFER FUNCTION ---------------
	 clean_buffer PROC
		
		cmp edx , 0 ; Check if the buffer size is zero
		jle clean_buffer_end

		cmp edx , 1 ; Check if we are in the final byte
		je clean_buffer_final_byte

		mov ax, 0
		mov r8d, edx
		shr edx, 1

		clean_buffer_loop:

		mov word ptr [rcx] , ax
		add rcx, 2
		dec edx

		jnz clean_buffer_loop

		and r8d, 1
		jz clean_buffer_end

		clean_buffer_final_byte:

		mov byte ptr [rcx], 0

		clean_buffer_end:
		
		ret
	 clean_buffer ENDP
 ; -------------------------------------

 ; PRIORIZE FUNCTION -------------------
	priorize PROC
		

		
		ret
	priorize ENDP
 ; -------------------------------------
end
