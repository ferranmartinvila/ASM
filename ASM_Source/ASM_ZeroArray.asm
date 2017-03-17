.code

; ZeroArray(void* arr, int count_in_bytes)
; rcx is the first parameter (arr)
; edx is the second (count_in_bytes)
; this is just because we are using a microsoft file system
; mox ax, 0
; valve edx, 

; Set all bytes from *RCX to *RCX + EDX to 0
ZeroArray PROC
	
	cmp edx, 0 ; Check for 0 or less
	jle Finished ; Jump less or equal
	
	
	cmp edx, 1 ; Check for 1
	je SetFinalByte

	mov ax, 0		; Set ax TO 0
	mov r8d, edx	; Save the original count to r8d
	shr edx, 1		; Halve the count because we're using AX, not AL

MainLoop:

	mov word ptr [rcx], ax	; Set two bytes to 0
	add rcx, 2				; Move RCX to the next two bytes
	dec edx					; Decrement our counter
	jnz MainLoop			; Jump if we have more to set

	and r8d, 1	; Check if there was an even number
	jz Finished	; If there was, we're done!

SetFinalByte:

	mov byte ptr [rcx], 0

Finished:


	ret

ZeroArray ENDP
end