volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;
 
void print_uart0(const char *s) {
	while(*s != '\0') { /* Loop until end of string */
	*UART0DR = (unsigned int)(*s); /* Transmit char */
	s++; /* Next char */
 }
}
 
void c_entry() {
	print_uart0("Hello world!\n");
}

void c_space(){
	while(1) {
		int i=0; 
		print_uart0(" ");
		for (i=0; i<100000; i++);
	}
}

void c_asterisk(){
	while(1) {
		int i=0; 
		print_uart0("*");
		for (i=0; i<100000; i++);
	}
}
