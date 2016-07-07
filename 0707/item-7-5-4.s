	.text
    .globl main
main:
	ADR	r0, array			@ endereco do array
	MOV	r1, #0				@ contador
	LDR	r2, =0x03ff5008		@ endereço IOPDATA
	LDR r3,[r2]				@ salvamos IOPDATA em r3

loop:
	CMP r1,	#11				@ comparo r1 (contador) com 11(tamanho do vetor)
	BGT	end					@ se r1 > tamanho array termino o loop
	
	LDR	r5, [r0], #4		@ leio a array e atualizo o endereço da array para o proximo item

	CMP r5, #16				@ comparo com 16 			
	BCS	loop 				@ se for >= 16, volto pro loop
	AND	r3, r3, #0			@ zeramos r3
	
	CMP	r5, #0
	MOVEQ r3, #0x17c00		@ codigo pra 0
	BEQ	break

	CMP	r5, #1
	MOVEQ r3, #0x1800		@ codigo pra 1
	BEQ	break

	CMP	r5, #2
	MOVEQ r3, #0xeC00		@ codigo pra 2
	BEQ	break

	CMP	r5, #3
	MOVEQ r3, #0xbc00		@ codigo pra 3
	BEQ	break

	CMP	r5, #4
	MOVEQ r3, #0x19800		@ codigo pra 4
	BEQ	break

	CMP	r5, #5
	MOVEQ r3, #0x1b400		@ codigo pra 5
	BEQ	break

	CMP	r5, #6
	MOVEQ r3, #0x1f400		@ codigo pra 6
	BEQ	break

	CMP	r5, #7
	MOVEQ r3, #0x01c00 		@ codigo pra 7
	BEQ	break

	CMP	r5, #8
	MOVEQ r3, #0x1fc00		@ codigo pra 8
	BEQ	break

	CMP	r5, #9
	MOVEQ r3, #0x1bc00		@ codigo pra 9
	BEQ	break

	CMP	r5, #10
	MOVEQ r3, #0x1dc00		@ codigo pra A
	BEQ	break

	CMP	r5, #11
	MOVEQ r3, #0x1f000		@ codigo pra b
	BEQ	break

	CMP	r5, #12
	MOVEQ r3, #0x16400		@ codigo pra C
	BEQ	break

	CMP	r5, #13
	MOVEQ r3, #0x0f800		@ codigo pra d
	BEQ	break

	CMP	r5, #14
	MOVEQ r3, #0x1e400		@ codigo pra E
	BEQ	break

	CMP	r5, #15
	MOVEQ r3, #0x1c400		@ codigo pra F
	BEQ	break

break:
	STR	r3, [r2], #0		@ salvamos r3 em IOPDATA
	B loop					@ voltamos para o loop


end:
	SWI #0x123456			@ fim do programa

array:
	.word	0,1,2,3,4,5,6,7,8,9,10
