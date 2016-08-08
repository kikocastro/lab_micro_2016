#include <stdio.h>

unsigned int * const TIMER0X = (unsigned int *)0x101E200c;

void handler_timer(){
	*TIMER0X = 0;
}
