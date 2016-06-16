	.text
	.globl main
main:
	LDR r1, =302
	MOVS r2, #10
	MOV r10, #1
	MOV r3, #0
	MOV r5, #0
	MOV r10, r10, LSL #31
	BEQ end
	
	CMP r1, r2
	BMI end
	
	MOV r4, #1
	BL shift32
	
	BL divisao
	
	B end
	
shift32:
	CMP r2, r10
	MOVLS r2, r2, LSL #1
	MOVLS r4, r4, LSL #1
	BLS shift32
	MOV pc, lr
divisao:
	CMP r1, r2
	SUBHS r1, r1, r2
	MOV r3, r3, LSL #1
	ADDHS r3, r3, #1
	CMP r4, #1
	MOVEQ r5, r1
	MOVEQ pc, lr
	MOVNE r2, r2, LSR #1
	MOVNE r4, r4, LSR #1
	BNE divisao	
end:
	SWI 0x1234
	

