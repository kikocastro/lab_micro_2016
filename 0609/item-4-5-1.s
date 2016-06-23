	.text
	.globl main
main:
		MOV 	r0, #0
 		MOV 	r1, #1
		ADR		r2, array
		LDR		r0, [r2], #20
		LDR		r0, [r2], #20
		ADD		r0, r0, r1

		SWI	0x123456
		
array:  .word 0, 1,2,3,4,5, 6, 7, 8, 9, 10, 11, 12, 13, 14,15,16,17,18,19,20,21,22,23,24			
		

