.code
JumpExFunction PROC

	mov ecx, 10

	MainLoop:
	dec ecx ; dec ecx == ecx--
	jnz MainLoop ; This jump check if the ecx is not equal to zero and if the cmp is true it jump to the MainLoop label

	ret

JumpExFunction ENDP
end