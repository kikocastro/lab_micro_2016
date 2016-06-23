	.text
	.globl main
main:
			ADR, r0, length 	/* r0 = &tamanho */
			ADR, r1, input 		/* r1 = &input */
			LDR, r0, [r0]		/* r0 = tamanho */
swap:
			LDR, r2, 

end:	
			SWI 0x123456
	
length: 	.word 5
input: 		.word 5,1,4,2,3