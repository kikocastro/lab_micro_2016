#define TIMER0X ((volatile unsigned *)(0x101E200c))
volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;
/*volatile unsigned int * const TIMER0X = (unsigned int *)0x101E200c;*/
 
void print_uart0(const char *s) {
 while(*s != '\0') { /* Loop until end of string */
 *UART0DR = (unsigned int)(*s); /* Transmit char */
 s++; /* Next char */
 }
}
 
/*void handler_timer() {

 *TIMER0X = (unsigned int)0x00;
 print_uart0("1 ");
 return;

}
*/
void hello(){
	print_uart0("Hello World");
}
/*
void stop(){
	print_uart0("2");
	return;
}


void handler_timer(){
	*TIMER0X = 0x00;
	print_uart0("############1");
	return;

}*/

void print_1(){
	print_uart0("1");
	return;
}

void print_2(){
	print_uart0("2");
	return;
}