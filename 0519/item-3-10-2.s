	.text
	.globl main
main:
	LDR	r7, =0x1	
	SUB r11, r12, r3, LSL #32		
	LDR	r2, =0x80000000
	BL	firstfunc		
	MOV	r0, #0x18		
	LDR	r1, =0x20026		
	SWI	0x123456		
firstfunc:
	MULS	r0, r1, r2		
	MOV		pc, lr			
