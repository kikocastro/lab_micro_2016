	.text
	.globl main
main:
			LDR r1, =0x2 /* b */
			LDR r2, =0x5 /* c */
			LDR r3, =0x1 /* d */
			LDR r4, =0x8000 /* end de inicio dos parametros */
			STMFD r4!, {r1, r2, r3} /* salva na pilha os parametros */
			BL func1	
			SWI 0x123456
func1:
			LDMFD r4!, {r5, r6, r7} /* carrega os parametros da memoria  */
			MUL r0, r5, r6 /* a = b x c */
			ADD r0, r0, r7 /* a = a + d */
			MOV pc, lr 		
