	.text
	.globl main
main:
			LDR r1, =0x2 /* b */
			LDR r2, =0x5 /* c */
			LDR r3, =0x1 /* d */
			LDR r4, =0x8000 /* end de inicio dos parametros */
			STMFD r4!, {r1, r2, r3} /* salva na pilha os parametros */
			BL func1
			BL func2	
			SWI 0x123456
func1:
			LDMFD r4, {r5, r6, r7} /* carrega os parametros da memoria */
			MUL r1, r5, r6 /* a = b x c */
			ADD r1, r1, r7 /* a = a + d */
			MOV pc, lr /* retorna resultado em r1 */
func2:
			LDMFD r4, {r5, r6, r7} /* carrega os parametros da memoria */
			MUL r2, r5, r6 /* a = b x c */
			ADD r2, r2, r7 /* a = a + d */
			MOV pc, lr 	/* retorna resultado em r2 */

