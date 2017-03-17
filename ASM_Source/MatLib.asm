.code

; SUM FUNCTION

sum PROC
	
	mov edx, edx
	add eax, edx
	ret

sum ENDP

; int multiply(int a, int b)
; return a * b

mult PROC
	
	; mov eax, ecx
	; imlut edx
	
	imul ecx, edx ; multiply the operands
	mov eax, ecx ; put the answer to eax to return it

	ret

mult ENDP

; int divide(int a,int b)
; return a/b

divide PROC

	mov r8d , edx ; Now r8d is the divisor
	mov eax, ecx ; Now eax is the dividend 


	cdq ; convert to sign extended, fills edx with the sign bit of eax

	idiv r8d ; in idiv the answer is put in eax 

	ret

divide ENDP

rem PROC

	mov r8d , edx ; Now r8d is the divisor
	mov eax, ecx ; Now eax is the dividend 


	cdq ; convert to sign extended, fills edx with the sign bit of eax

	idiv r8d ; in idiv the answer is put in eax 
	mov eax,edx ; Chuck it into EAX to return
	ret

rem ENDP

clean_buffer PROC
	; rcx is the buffer
	; edx is the buffer size

	cmp edx, 0 ; Check if the buffer size is 0
	jle FUNCT_END

	LOOP:

	mov ecx ptr dword [edx],0 ; Set the current buffer cell to 0 
	dec edx ; decrement the value of edx

	cmp edx, 0 ; check if the edx (index val) is 0
	jnz LOOP ; This checks the cmp result & if !0 jump to the LOOP label
	
	FUNCT_END:

	ret
clean_buffer ENDP

sum_array_values PROC
	; ecx is an int array
	; edx is the size of int array
	; This function returns a int (eax is the return register)

	; Check if the size of the array is zero
	cmp edx , 0 ;
	jle FUNCTION_END

	LOOP:

	; Add the current cell of the array value
	add eax , ecx [edx]
	dec edx

	cmp edx, 0 ; cmp returns zero if the condition is true
	jnz LOOP

	FUNCTION_END:
	
	ret
	
sum_array_values ENDP 

priorize_array PROC
	
	ecx ; Is the buffer variable
	edx ; Is the buffer size

	cmp edx, 0 ; Check if the buffer size is zero
	jle FUNCT_END ; If the array size is zero the function ends
	
	; Set a pointer to the last
	LOOP:

	mov ecx ptr dword [edx],0; This is like ecx[edx] = 0
	dec edx ; This is like index--

	; Check if the array is completely iterated
	cmp edx , 0 
	jnz LOOP

	; Go here wheren the process is finished
	FUNCT_END
	ret

priorize_array ENDP
;Function to get the absolute value of a integrer
abs_val PROC

	mov ecx, eax ; Duplicate the ecx value in the eax register
	shr ecx, 31 ; Shift 31 bytes at the left so now ecx have only the value sign value
	xor eax, ecx; Check the value of ecx as binary
	sub eax, ecx; Substract ecx at eax 
	ret

abs_val ENDP


end