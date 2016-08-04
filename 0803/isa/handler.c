//Erick Kenji Iwashita
//Isabella Pimentel de Moraes
//Rafael Yudi Imai

volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;
volatile unsigned int * const TIMER0X = (unsigned int *)0x101E200c;
 
void print_uart0(const char *s) {
 while(*s != '\0') { /* Loop until end of string */
 *UART0DR = (unsigned int)(*s); /* Transmit char */
 s++; /* Next char */
 }
}

void c_entry() {
	print_uart0("Hello World! \n");
}

void handler_timer() {
	*TIMER0X = 0; // limpa o pedido de interrupção
	print_uart0("1");
}

void timer_idle() {
	int i = 0;
	print_uart0("2");
	for (i = 0; i<100000; i++){

	}
}
