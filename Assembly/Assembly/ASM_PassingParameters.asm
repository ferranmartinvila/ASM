; ------	Qword		Dword		Word		Byte
; 1			rcx			ecx			cx			cl
; 2			rdx			edx			dx			dl
; 3			r8			r8d			r8w			r86
; 4			r9			r9d			r9w			r96
; >4		stack		stack		stack		stack
; To return an int, just have it in the 
; appropriate size of RAX.
.code
PassingParameters PROC

	mov ax, cx
	add ax, dx
	add ax, r8w
	add ax, r9w
	;cmp edx, eax
	;ja ReturnEAX

	;mov eax, edx ; the returned value is the valua allocate in the smaller register edx < ecx

	ret

	ReturnEAX:
	ret

PassingParameters ENDP
end