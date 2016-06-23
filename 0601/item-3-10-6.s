	.text
	.globl main
main:
	LDR r0, =0xFFFFFFFF
	ADD r1, r0, r0, LSR #31 ;Shift de 31 a direita do valor inicial
	EOR r1, r1, r0, LSR #31 ;XOR com o valor shiftado 
	
	SWI	0x123456
