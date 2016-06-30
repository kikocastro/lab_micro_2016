	.text
	.globl main
main:
	MOV r0, #1				; F[0] = 1
	MOV r1, #1				; F[1] = 1
	LDR r10, =0x4000		; valor inicial a ser salvo na memória
	LDR r11, =0x400C		; valor final para comparação
	STRB r0, [r10]			; salvamos 1 em 0x4000
	STRB r0, [r10, #1]!		; salvamos 1 em 0x4001 e incrementamos r10
loop:
	ADD r2, r0, r1 			; F[n] = F[n-1] + F[n-2]
	MOV r1, r0 				; F[n-2] = F[n-1]
	MOV r0, r2				; F[n-1] = F[n]
	STRB r0, [r10, #1]!		; Salvamos F[n] na posição de memória correspondente e incrementamos r10
	CMP r10, r11			; if r10 == r11
	BEQ end					; termina programa
	B   loop				; volta pro loop
end:
	SWI 0x123456			; fim do programa
