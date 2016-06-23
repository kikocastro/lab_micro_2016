	.text
	.globl main
main:
		ADR		r1, array_a	 			/* r1 = &a */
		ADR 	r2, array_b 			/* r2 = &b */
		MOV 	r3, #0 					/* i = 0 */
		MOV 	r4, #2 					/* c = 2 */
loop: 
		CMP 	r3, #11 				/* i == 11 */
		BEQ 	end						/* se i > 10 termina */
		LDR 	r5, [r2, r3, LSL #2]  			/* r5 = b[i] */
		ADD 	r5, r5, r4				/* r5 = r5 + c */
		STR 	r5, [r1, r3, LSL #2] 	/* a[i] = r5 */
		ADD 	r3, r3, #1 				/* i++ */
		B  		loop 
end: 	
		SWI	0x123456
		
array_b: 	.word 0xA, 1,2,3,4,5, 6, 7, 8, 9, 10, 11, 12, 13, 14,15,16,17,18,19,20,21,22,23,24			
array_a:	.space 24
