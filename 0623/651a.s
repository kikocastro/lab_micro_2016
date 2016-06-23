	.text
	.globl main
main:
			LDR r1, =0x2
			LDR r2, =0x5
			LDR r3, =0x1
			BL func1
			SWI 0x123456
func1:
			MUL r0, r1, r2
			ADD r0, r0, r3 
			MOV pc, lr
