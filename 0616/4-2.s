	.text
	.globl main
main:
	LDR 	r0, =0x5555AAAA		/* entrada */
	MOV 	r1, #0			/* saida */
	LDR 	r8, =0xA			/* padrao */
	MOV 	r9, #4  		/* tamanho da padrao */
	LDR 	r2, =0x80000000	/* mascara = 1 no MSB */
	LDR 	r10, =0x80000000/* constante */
	MOV 	r3, #1 			/* contador i = 1 (ja temos um bit na mascara) */
	RSB 	r11, r9, #32    /* referencia do tamanho maximo */
	MOV 	r11, r8, LSL r11/* padra movido para a esquerda */	
loop: 	
	CMP 	r3, r9 			/* i < tamanho do padrao ? */
	BGE		doMasking
	BL 		concatOneLeft
	ADD 	r3, r3, #1 		/* i++ */
	B 		loop
concatOneLeft: 				/* concatena 1 a esquerda na mascara */
	MOV 	r2, r2, LSR #1	/* mascara shiftada r2 = r2 >> 1 */
	ADD 	r2, r2, r10	    /* adiciona 0x80000000 */
	MOV 	pc, lr
doMasking:
	MOV 	r1, r1, LSL #1	/* shift no resultado */ 
	AND 	r5, r2, r0 		/* r5 = mascara shiftada AND entrada */
	EORS 	r6, r11, r5 	/* r6 = padrao shiftado XOR resultado do AND */
	ADDEQ 	r1, r1, #1		/* somo um no resultado se XOR deu 0 */
	MOVS 	r2, r2, LSR #1  /* mascara anda para esquerda */
	MOV 	r11, r11, LSR #1 /* shift do padrao */
	BCC 	doMasking
end:
	SWI	0x123456
