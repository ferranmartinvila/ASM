.data
MyByte db 10

.code
JumpFunction proc
	; Unconditional jump
	; jmp[register/memory/label + offset]
	

	; Compare Instruction
	;cmp [register/memory] [register/memory/ imm]

	mov ecx, 89
	mov ebx, 56
	cmp ecx, ebx
	jg MyLabel

	; Conditional Jumps
	; jxx [label + offset]
	; je/jz - jump equal / jump zero
	; jne/jnz - jump not equal / jump not zero
	; jl/jb - jump if less / jump below
	; jle - jump if less or equal
	; jg/ja - jump if greater / ja don't care about the sign
	; jge - jump if greater or equal
	mov rbx, MyLabel
	add rbx, 23

	jmp MyLabel + 23

	jmp MyLabel

	mov eax, 25

MyLabel:
	ret

JumpFunction endp
end