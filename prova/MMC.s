	.text
        .globl main

main:

	mov 	r1, #4
	mov 	r2, #6
	mov 	r8, #0					@flag
	mov 	r9, #2					@auxiliar
	mov 	r10, #1					@MMC temporário
	mov 	r11, #1
	mov 	r12, #2


	adr		r6, array				@[a][b][a>1][b>1][a%aux][b%aux]
	mov 	r7, r6					@comeco array

	cmp 	r1, #0 					@if (a != 0 && b != 0)
	beq 	fim

	cmp 	r2, #0
	beq 	fim

	str		r1, [r6], #4
	str		r2, [r6], #4
	str		r11, [r6], #4
	str		r12, [r6], #4

while:

	mov 	r11, #0
	mov 	r12, #0
	
	mov 	r6, r7					@while(a>1 || b>1)
	ldr 	r11, [r6], #8
	cmp 	r11, #1
	strls 	r12, [r6], #0

	mov 	r6, r7
	ldr 	r11, [r6, #4]
	cmp 	r11, #1
	strls	r12, [r6, #8]

	mov 	r6, r7
	ldr		r11, [r6, #8] 
	ldr		r12, [r6, #4]
	cmp 	r11, r12
	beq 	fim

	mov 	r6, r7					@if (a>1)
	ldr 	r11, [r6, #8]
	cmp 	r11, #1
	bls 	fazB
	
	mov 	r6, r7
	ldr		r1, [r6], #4
	mov 	r2, r9
	bl 		divide

	mov 	r6, r7

	cmp 	r5, #0
	streq	r3, [r6], #4
	muleq 	r10, r10, r9
	moveq	r8, #1

	mov 	r6, r7
	str 	r5, [r6, #16]



fazB:								@if (b>1)

	mov 	r6, r7
	ldr		r1, [r6, #4]
	mov 	r2, r9
	bl 		divide

	mov 	r6, r7
	cmp 	r5, #0
	streq	r3, [r6, #4]
	cmp 	r8, #0
	muleq 	r10, r10, r9

	mov 	r6, r7
	str 	r5, [r6, #20]

	mov 	r6, r7

	
	ldr 	r11, [r6, #16]			@if (a%aux != 0 && b%aux != 0)
	cmp 	r11, #0
	beq 	flag
	ldr 	r12, [r6, #4]
	cmp 	r11, #0
	beq 	flag
	add 	r9, r9, #1

flag:
	
	mov 	r8, #0
	b 		while
	
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


array:
	.word	4, 9, 2, 3, 5, 7, 8,
