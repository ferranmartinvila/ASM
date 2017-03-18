; shr ; shift right [reg/mem], [imm8/cl] <- cl is the only register we can use
; shl ; shift left
; sar ; shift arithmetical right
; sal ; shift arithmetical left


; shr al, 4 ; This moves the al bites 4 cells at the right and the free cells of the left container are setted to 0
; before -> al [0,1,1,1,0,0] // after -> al [0,0,0,0,0,1]

; shl al, 4 ; Is the same as shr but in left direction and right empty cells are settled to 0

; Useful in registers reappointing
; shr al, 4  // al = al / 2^4		Use shifting right is like moving the register the shift value elevated at two
; shl al, 4  // al = al * 2^4		Use shifting left is like moving the register the shift value elevated at two 

; The first bite of a container represents the sign of the value so where we are useing shl/shr maybe we are changing the sing
; And thats why arithmetical shifts were invented

; Arithmetical shift fill the extreme empty cells after the bites movement with the value sign


; shrd ; shift right double precision
; shld ; shift left double precision
;[reg/mem],[reg],[imm/cl]

; shrd ax,dx,4 ; This is a normal shr at the ax value but the empty extreme cells are filled with the dx value that can get in

; shld ax,dx,5 ; 

; This shift are usefull for packing and unpacking data

; ax 1
; bx 2
; cx 3
; dx 4

;Packing
; shrd rdi, rax, 16 ; rdi = [ax,0,0,0]
; shrd rdi, rbx, 16 ; rdi = [bx,ax,0,0]
; shrd rdi, rcx, 16 ; rdi = [cx,bx,ax,0]
; shrd rdi, rdx, 16 ; rdi = [dx,cx,bx,ax]


;Unpacking
; shld rdx,rdi,16 ; rdi = [cx,bx,ax,0]
; shld rcx,rdi,16 ; rdi = [bx,ax,0,0]
; shld rbx,rdi,16 ; rdi = [ax,0,0,0]
; shld rax,rdi,16 ; rdi = [0,0,0,0]

end