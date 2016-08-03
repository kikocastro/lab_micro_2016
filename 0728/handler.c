
	// handler_timer:
	// 	STMFD sp!, {r0-r12, lr}
	// 	LDR r0, TIMER0X
	// 	MOV r1, #0x0
	// 	STR r1, [r0] 			@Escreve no registrador TIMER0X para limpar o pedido de interrupção
	// 	Inserir código que sera executado na interrupção de timer aqui (chaveamento de processos,  ou alternar LED por exemplo)
	// 	LDR r0, LED_SW
	// 	ADD r0, r0, #0x1
	// 	MOVVS r0, #0x0
	// 	AND r0, r0, #0xf0
	// 	LDR r1, =0x3ff5000		@ IOPMOD
	// 	STR r0, [r1]			@ seta IOPMOD como output
	// 	LDMFD sp!, {r0-r12,lr}
	// 	MOV pc, lr

volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;
volatile unsigned int * const TIMER0X = (unsigned int *)0x101E200c;
 
void print_uart0(const char *s) {
 while(*s != '\0') { /* Loop until end of string */
 *UART0DR = (unsigned int)(*s); /* Transmit char */
 s++; /* Next char */
 }
}
 
void c_entry() {
 print_uart0("Hello world!\n");
 return;
}

void handler_idle() {
	print_uart0("2");
	return;	
}

void handler_timer() {
	// *TIMER0X = 0;
	print_uart0("1");
	
}


