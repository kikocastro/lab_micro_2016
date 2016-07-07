	.text
	.globl main
main:
	LDR r3, =0x03ff5008		@ endereço IOPDATA
	ADR r2, memoria			@ pegamos o número na memória
	LDR r1, [r2]			@ salvamos no registrador
	CMP r1, #16				@ comparamos com 16
	BCS maior				@ se for >= 16, zeramos os leds
	LDR r4, [r3]			@ salvamos em r4 que estiver em IOPDATA
	AND r4, r4, #0			@ zeramos os leds
	MOV r1, r1, LSL #4		@ shiftamos r1 para alinhar com os leds
	ADD r4, r4, r1			@ somamos a r4
	STR	r4, [r3]			@ salvamos em IOPDATA
	B 	end					@ vamos para o fim
maior:
	LDR r4, [r3]			@ salvamos em r4 o que estiver em IOPDATA
	AND r4, r4, #0			@ zeramos os leds
	STR	r4, [r3]			@ salvamos em IOPDATA
	B 	end					@ vamos para o fim
end:
	SWI 0x123456			@ fim do programa

memoria:
	.word 0xc
