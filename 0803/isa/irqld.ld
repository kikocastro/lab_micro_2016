ENTRY(_start)
SECTIONS
{
	. = 0x0;
	.text : { * (.text); }
	. = . + 0x1000; /* 4kB of stack memory */
	stack_top = .;
	. = . + 0x1000; /* 4kB of stack memory */
	stack_top_irq = .;
}
