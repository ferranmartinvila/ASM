;The data section contains anything that you want to be automatically initialized for you
; by the system before it calls the entry point of your program
.data
mybyte db 0
mybyte2 db 9

.code
MovTestFunction proc
	;mov [register/value] [variable/value] [register / variable] [variable/register]
	mov rax,267
	mov ecx, ebx
	mov bl, mybyte
	mov mybyte, ch
	mov mybyte, 42 ;You can not move var to var (mov mybyte, mybyte2) dont work

	ret
MovTestFunction endp

AddTestFunction proc
	; add [register/memory], [register/memory/imm]
	mov rax,2
	add rax,7
	add rax,rbx

	; sub [register/memory], [register/memory/imm]
	mov rbx, 20
	mov rcx, 7
	sub rbx, rcx

	ret
AddTestFunction endp

end