.data
myword db 0

.code

Pointers PROC

	;mov rbx, [5]; This moves the rbx register to the cell 5 of the ram so now rbx is a pointer to the cell 5
				 ; But this crashes because windows don't let noobs read low memory cells
	
	mov rbx, 5 ; This just put the value of 5 in the rbx register
	 
	mov cl, bl ; This puts bl cell value in cl so now cl = 5

	;mov cl, [rbx]	; This puts the inside rbx cell value in cl register but here rbx value is 5
					; and remember that you are a noob 

	mov cl, byte ptr[rbx] ; This move the value of [rbx] memory cell in cl register
						  ; And byte ptr is like a cast to say assembler that the value is 
						  ; (in this case) a byte size value

	mov byte ptr [rbx], 11 ; This move 11 value in the [rbx] cell


	;LEA Lead Effective Address

	;mov lx, myword ; This loads the myword value in lx register Ex: 22
	lea rbx, myword ; But this load the myword cell number in the rbx register Ex: 0x0003

	mov cx, 20 ; This put hte value 20 in cx 
	mov word ptr [rbx], cx ; This put the cx value (20) in the register rbx coordenate that we have puted before with lea
						   ; So rbx now is like a pointer to the myword cell

						   ; This is not c++ so if you modify an adress you have to move the data type byte size in cells
						   ; int* p; p++; <- This moves automatically 4 bytes but in assembly this don't work

	lea rbx, myword ; Now rbx contains the coordinate of myword in ram memory

	inc rbx ; This is like a ++ so this moves rbx "pointer value" only one cell 

	mov word ptr [rbx], cx ; This is the correct woy to move a word size in cells the pointer

	add rbx, 100000 ; This makes that rbx pointer moves 100000 cells in ram memory

	shl rbx, 41 ; shift left is like multiplying rbx pointer value by 41

Pointers ENDP
end