	.text
	.globl main
main:
		MOV 	r0, #0 			
		ADR		r1, array_a 		
		ADR		r2, array_b 	
loop:
		CMP 	r0, #8			
		BEQ     end				
		RSB		r3, r0, #7		
		LDR		r4, [r2, r3]	
		STR		r4, [r1, r0]	
		ADD		r0, r0, #1		
		B 		loop		 					
end:	
	SWI	0x123456
array_a: .word 1,2,3,4, 5, 6, 7
array_b: .word 11,12,13,14, 15, 16, 17

