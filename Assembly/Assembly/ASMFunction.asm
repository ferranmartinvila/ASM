.data
mybyte db 0
mybyte2 db 9

.code
TestFunction proc
	; add [register/memory], [register/memory/imm] - Addition
	mov rax,2
	add rax,7
	add rax,rbx

	; sub [register/memory], [register/memory/imm] - Substract
	mov rbx, 20
	mov rcx, 7
	sub rbx, rcx
	sub cl, mybyte2

	; neg [register/memory] - Negate
	mov rax, 89
	neg rax
	neg rax

	; inc [register/memory] - Increment
	inc rax
	inc mybyte

	; dec [register/memory] - Decrement
	dec edi
	dec mybyte2

	; xchg [register/memory], [register/memory] - Exchange
	mov rax, 2
	mov rbx, 5
	xchg rax, rbx

	ret ; Return instruction

TestFunction endp
end