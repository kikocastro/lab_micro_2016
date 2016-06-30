	.text
	.globl main
main:
	MOV r0, #6				;valor a ser verificada a paridade
	MOV r1, #0				;saída
loop:
	MOVS r0, r0, LSR #1		;shift para a direita joga o bit pro carry
	MOVCS r2, #1			;se C = 1, movemos 1 para r2
	MOVCC r2, #0			;se C = 0, movemos 0 para r2
	EOR r1, r2, r1			;r1 xor r2
	MOVS r0, r0				;atualizamos as flags com o valor de r0
	BNE loop				;se r0 != 0 volta pro loop
end:
	SWI 0x123456			;fim do programa
