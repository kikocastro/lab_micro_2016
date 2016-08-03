ENTRY(_start)
SECTIONS
{
 . = 0x00000;
 .text :{
 	irq.o (INTERRUPT_VECTOR)
 	*(.text)
 }
 .data : { *(.data) }
 .bss : { *(.bss COMMON) }
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 stack_top = .;
}

