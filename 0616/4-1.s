	.text
	.globl main
main:
	LDR 	r1, =91  		/* x = 1011011 */
	MOV 	r2, #0
st0:
	MOVS	r1,r1, LSL #1 	/* coloca MSB no carry */	
	MOV 	r2,r2, LSL #1
	BEQ		end				/* Se r1==0 termina */ 	
	BCC		st0	 			/* Se carry for 0, continua em st0, se for 1, avanca a SFM */
st1:
	MOVS	r1,r1, LSL #1 	/* coloca MSB no carry */	
	MOV 	r2,r2, LSL #1
	BEQ		end				/* Se r1==0 termina */ 	
	BCS		st1	 			/* Se carry for 1, continua em st1, se for 0, avanca a SFM */
st2:
	MOVS	r1,r1, LSL #1 	/* coloca MSB no carry */	
	MOV	 	r2,r2, LSL #1
	BEQ		end				/* Se r1==0 termina */ 	
	BCC		st0	 			/* Se carry for 0, volta para st0, se for 1, avanca a SFM */
st3:
	MOVS	r1,r1, LSL #1 	/* coloca MSB no carry */	
	MOV 	r2,r2, LSL #1
	BCC		st2 			/* Se carry for 0, vai para st0, se for 1, avanca a SFM para estado de aceitacao */
	ADD 	r2,r2, #1		/* saida 1 para aceitacao */
	BEQ		end				/* Se r1==0 termina */ 	
st4:
	MOVS	r1,r1, LSL #1 	/* coloca MSB no carry */	
	MOV 	r2,r2, LSL #1
	BEQ		end				/* Se r1==0 termina */ 	
	BCS		st4	 			/* Se carry for 1, continua em st4, se for 0, retorna para st2 */
	B 		st2
end:
	SWI	0x123456
