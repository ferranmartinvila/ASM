
; [label / size / value/?] ? just allocate the data size
; mybyte byte 0

; byte: db, byte, sbyte
; word: dw, word, sword
; dword: dd, dword, sdword
; qword: dq, qword, sqword
; xmmword: xmmword
; ymmword: ymmword

; float: real4
; double: real8
; ??: real10 - x87 floating point unit

; myFloat real4 10.0 <- Is needed to define the decimal part or we can just put a ?

.data
my_byte_array db 1000 dup (0)	;This defines an array of 1000 bytes <- dup (0) put all the cells the 0 value
								; If we put a ? in the dup the memory allocated have de defautl data

my_word_array dw 10 dup (7 dup (6)) ; This is a double array with 10x7 with 6 value in cells 

my_var db 1,2,3,4 ; This is a array of byte size with value 1,2,3,4 in cells

my_other_array db 10 dup (1,2,3,4,5) ; This allocate a byte array of 10 cells with the 1,2,3,4,5 inside so size = 10x5

my_byte_aay db 'jkdkdhjjkljlafj',0 ; Array that contains the string and 0 at end
my_bye_array db 'jkdkdhjjkljlafj'  ; Array that contains the string


; Data include
 ;file 'data.bin' ; This will include the whole file as binary
 ;file 'data.bin' : 10h,4 ; Will include only 4 bytes starting at offset 10h

; Constants & albels
; Constants are variables defined with a numeric value
;ex:  
; count = 17 ; Define count constant with 17 value
; mov eax, count; Now this is like mov eax, 17

;Casts
; mov ax, char ; This will cause an error because char is different memory size of ax
; mov ax , word [char] ; This force assembly to get char as a word byte size data
; mov can only interact with data of the same size

; XCHG
; xchg ; Swap the content of two operands

; PUSH
; push ; 	Transfer the data to the stack indicated by esp
; pushw ; To push a word mem size
; pushd ; To push a double word mem size

; POP
; pop ; Put the top of the esp pointed stack at the variables

; MOVSX
; movsx ; Converts the type of the second operand to the first one
; movsx ax, byte [bx] ; This transforms byte bx register to word ax register
; movsx eax, ax ; This transforms word ax register to double word eax register
; movsx uses the sign extension
; movzx don't use the sign extension
; The sign extension fill the extra bytes with the value of the sign

; ADD
; add ; Replaces first operand with the sum of the two input operands
; add sets CF if overflow has occurred
; adc ; do the same as add & adds one if CF is sets

; MATHEMATIC METHODS
; inc ; Increment one to the operand
; dec ; Decrement the operand by one
; sub ; Substracts the source operand from the destination operand & replaces the destination operand with the result
; cmp ; This really subtracts the source op to the destination but only set the flag and don't alter the operands
; neg ; This really subtracts a signed zero so the sing value becomes negative or positive
; xadd ; This swaps the destination operand with the source operand and load the sum of two values into the destination operand
; xadd ; The source operand must be a register

; SF/ZF/PF/OF flags
; This flags are modified in result of the commented binary operands
; SF ; Is set to the result bit sign so SF is the sign flag
; ZF ; Is true if all the result bits are zero so ZF is zero flag
; PF ; 
; OF ; Is true if the result is too large for the destination operand

; MULT/IMULT
; mult ; Performs a unsigned multiplication operand * accumulator 
; If the operand is a byte the processor mult it by contents of al and returns the 16 bites result at ah & al
; If the operand is a word the processor mult it by contents of ax and returns the 32 bites result at dx & ax
; If the operand is a double word the processor mult it by contents of eax and returns the 64 bites result at edx & eax
; imult ; Performs a signed multiplication operation 
; imult have three variations
; 1- first is the same as mult
; 2- This have two operands and destination operand is mult by source operand and the result replaces te destination operand
; destination operand must be a general register
; 3- This have thee operands , 1st the destination operand is a register, 2nd source operand is a register or memory , 3th must be a immediate value
; The source operand is mult by the immediate value and the result is stored in te destination operand
; -- exemples:
; imul bl ; accumulator by register
; imul word [si] ; accumulator by memory
; imul bx , cx ; register by register
; imul ax, bx, 10 ; register by immediate value to register
; imul ax, [si], 10; memory by immediate value to register 

; DIV/IDIV
; div ; Performs an unsigned division accumulator/operand
; idiv and div divide the whole register pair EDX:EAX this is why you need to extend the sign at EX register with cdq (for example)
; The dividend (accumulator) is twice size of the divisor (operand) & the quotient & remainder have the same size as the divisor
; If the divisor is byte size the dividend is taken from ax , the quotient is stored in al & remainder in ah
; If the divisor is word size the upper half of dividend is taken from edx, the lower half is taken from eax. The quotient is stored in eax & remainder is stored in edx
; idiv ; Performs a signed division accumulator/operand
; It uses the same register as div

; ARITHMETIC INSTRUCTIONS
; Decimal arithmetic instructions are used to adjust the results of a previous binary arithmetic operand to produce a valid packed or unpacked decimal result
; or to adjust the inputs to a subsequent binary arithmetic operator so the operation will produce a valid packed or unpacked decimal result
; add ; Adjusts the result of adding two valid packed decimal operands in al
; ... ; There are some other that instructions that I don't use for the moment

; LOGICAL INSTRUCTIONS
; not ; Inverts the bits in the specified operand (don't affrect flags)
; and, or , xor ; This instruction works like logical ones
; They update SF,ZF,PF
; bt/bts/btr/btc
; Operators that work with a single bit in memory or a register
; This operands first assign the value of the bit to CF 
; bt ; This only assign the value to CF
; bts ; This sets the selected bit to 1
; btr ; This sets the selected bit to 0
; btc ; This change the bit to its component
; -- exemples ;
; bt ax,15 ; This sets the CF to the value of last bit of ax register
; bts word [bx], 15 ; This sets CF to the bx last bit value and the set it to one
; btr ax,cx ; This sets CF to the ax cell in the cx value and then set that cell to zero
; btc word [bx], cx ; This sets CF to the bx cell of cx value and the replace that cell value for the component value

; BSF / BSR
; This operands scan a word or a double word and when a 1 value is find they stop and return the cell index at the destination operand
; bsf iterates from low order to high order
; bsr iterates from high order to high oreder
; If a 1 value is not found ZF is set

; SHIFTS 
; shl  ; Shifts the destination operand left by the number of the second operand
; The second operand can be an immediate value or the cl register
; The preocessor shifts zeros in from the right
; The last bit that exited is stored in CF
; shr ; Shift the destination operand right & have the same attributes as shr
; sar ; This is a shr that preserves the sign bit so the empty values after shift are set to sing value
; -- exemples ;
; shl al,1 ; Shift al register left by 1 bit (this move the register)
; shl byte [bx], 1 ; Shift memory left by one bit (this move the memory)
; shl ax,cl ; Shift register left by cl value
; shl word [bx],cl ; Shift memory left by cl value

; shld ; Shifts destination operand by the value of the third operand and fill the empty cells with the source operand
; -- examples ;
; shld ax,bx,1 ; shift left bx register by 1 and fill the empty cell with the ax register cells
; shld [di],bx,1 ; shift memory left by one bit  & and same as the previous examples

; shrd ; do the same as the shld in the right direction

; ROTATIONS
; rol ; Rotate the destination operand bite cells by the value of the source operand. So the value specifies the rotations, at every 
; rotation the lower & upper of the destination operand are swapped and the scope goes to upper - 1 & lower + 1

; CBW / CWD / CDQ
; CBW ; (Convert byte to word) Extends the sign bit of AL into AH register
; CWD ; (Convert word to dword) Extends the sign of AX into DX register
; CDQ ; (Convert dword to qword) Extends the sign of EAX into EDX register

end