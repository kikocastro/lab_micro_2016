	.text
	.globl main
main:
			LDR, r0, length 	/* r0 = tamanho */
			ADR, r1, input

end:	
			SWI 0x123456
	
length: 	.word 5
input: 		.word 5,1,4,2,3