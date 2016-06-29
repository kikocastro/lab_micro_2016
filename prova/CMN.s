	.text
        .globl main

    mov 	r10, #0 				@saída
    mov 	r1, #4					@a
    mov 	r2, #5					@b
    mov 	r11, r1
    mov 	r12, r2
    mov 	r4, #2 					@CMN
    mov 	r9, r4
    mov 	r8, #0 					@a%CMN
    mov 	r7, #0 					@b%CMN

while:

	cmp 	r9, r11
	bhi		fim

	cmp 	r9, r12
	bhi		fim

	cmp 	r10, #1
	beq		fim

	mov 	r1, r11					@if (a%CMN == b%CMN)
	mov 	r2, r9
	bl 		divide					
	mov 	r8, r5

	mov 	r1, r12
	mov 	r2, r9
	bl 		divide					
	mov 	r9, r5

	cmp 	r8, r9
	moveq 	r10, #1
	beq 	fim
	
	add 	r9, r9, #1
	b 		while

fim:
	SWI     0x123456

divide:
    CMP        r2, #0               @verifica se a divisão é por zero
    BEQ        divide_end

    MOV        r3, #0               @quociente
    MOV        r4, #1               @quociente temporário

setup:
    CMP         r2, r1              @verifica se dividendo é maior que divisor
    MOVLS       r2, r2, LSL #1      @caso seja, multiplica divisor por 2
    MOVLS       r4, r4, LSL #1      @multiplica por 2 quociente temporário tbm
    BLS         setup    

next:
    CMP       r1, r2                @verifica qm é maior
    SUBCS     r1, r1, r2            @se dividendo > divisor, dividendo - divisor
    ADDCS     r3, r3, r4            @portanto, coloca no quociente

    MOVS      r4, r4, LSR #1        @e divide os 2 para verificar se ainda "cabe" no dividendo
    MOVS      r2, r2, LSR #1
    
    BCC       next

divide_end:
    MOV         r5 ,r1              @r5 = resto
    MOV         pc, r14