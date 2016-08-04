@Erick Kenji Iwashita
@Isabella Pimentel de Moraes
@Rafael Yudi Imai

.global _start
.text
_start:
b _Reset							@posição 0x00 - Reset
ldr pc, _undefined_instruction		@posição 0x04 - Intrução não-definida
ldr pc, _software_interrupt			@posição 0x08 - Interrupção de Software
ldr pc, _prefetch_abort				@posição 0x0C - Prefetch Abort
ldr pc, _data_abort					@posição 0x10 - Data Abort
ldr pc, _not_used					@posição 0x14 -	Não utilizado
ldr pc, _irq						@posição 0x18 -	Interrupção (IRQ)
ldr pc, _fiq						@posição 0x1C -	Interrupção(FIQ)

_undefined_instruction: .word undefined_instruction
_software_interrupt: .word software_interrupt
_prefetch_abort: .word prefetch_abort
_data_abort: .word data_abort
_not_used: .word not_used
_irq: .word irq
_fiq: .word fiq


INTPND: .word 0x10140000 @Interrupt status register
INTSEL: .word 0x1014000C @interrupt select register( 0 = irq, 1 = fiq)
INTEN: .word 0x10140010 @interrupt enable register

TIMER0L: .word 0x101E2000 @Timer 0 load register
TIMER0V: .word 0x101E2004 @Timer 0 value registers
TIMER0C: .word 0x101E2008 @timer 0 control register
TIMER0X: .word 0x101E200c @timer 0 interrupt clear register

_Reset:
	ldr sp, =stack_top
	mrs r0, cpsr
	msr cpsr, 0x12 
	ldr sp, =stack_top_irq
	msr cpsr, r0
	bl  main
	b   .

undefined_instruction:
	b   .

software_interrupt:
	b   do_software_interrupt @vai para o handler de interrupções de software

prefetch_abort:
	b   .

data_abort:
	b   .

not_used:
	b   .

irq:
	b   do_irq_interrupt @vai para o handler de interrupções IRQ

fiq:
	b   .

do_software_interrupt:	@Rotina de Interrupção de software
	add r1, r2, r3		@r1 = r2 + r3
	mov pc, r14			@volta p/ o endereço armazenado em r14

do_irq_interrupt: @Rotina de interrupções IRQ
	sub r14, r14, #4		@Subtrai 4 de lr
	
	adr r12, linhaA 			@Coloca o endereço de linhaA em r12
	stmia r12!, {r0-r11}	 	@Salva os registradores r0-r11 em linhaA

	mrs r1, spsr;				@Copia spsr para r1
	str r1, [r12], #4 			@Armazena cpsr do surpevisor na linhaA
	mrs r1, cpsr 				@Salva cpsr atual 				
	msr cpsr, 0b10010011		@Muda para o modo supervisor
	stmia r12!, {sp, lr} 		@Armazena sp e lr de supervisor na linhaA
	msr cpsr, r1				@Volta para o modo interrupção
	str lr, [r12]	 			@Armazena lr do IRQ = pc do supervisor

	ldr r0, INTPND @Carrega o registrador de status de interrupção
	ldr r0, [r0]
	
	tst r0, #0x0010 @verifica se é uma interupção de timer
	blne handler_timer @vai para o rotina de tratamento da interupção de timer
	
	sub r12, r12, #12			@Retorna 3 endereços de linhaA
	ldmia r12!, {r1}		 	@Recupera o valor de cpsr
	msr cpsr, r1 				@Coloca o valor recuperado em cpsr
	ldmia r12!, {sp, lr} 		@Recupera os valores de sp e lr
	adr r12, linhaA 			@Pega o endereço base da linhaA
	ldmia r12!, {r0-r11} 		@Recupera os valores r0-r11 -> nao sei como recuperar 12 já que ele é necessário para percorrer os buffers
	add r12, r12, #12 			@Avança 3 endereços de linhaA
	ldr pc, [r12]				@Recupera pc e retorna

timer_init:
	ldr sp, =stack_top

	ldr r0, INTEN
	ldr r1,=0x10 @bit 4 for timer 0 interrupt enable
	str r1,[r0]

	ldr r0, TIMER0C
	ldr r1, [r0]
	mov r1, #0xA0 @enable timer module
	str r1, [r0]

	ldr r0, TIMER0V 
	mov r1, #0xff @setting timer value
	str r1,[r0]

	mrs r0, cpsr
	bic r0,r0,#0x80
	msr cpsr_c,r0 @enabling IRQs in the cpsr

	mov pc, lr

main:
	bl c_entry
	bl timer_init @initialize interrupts and timer 0
stop: 
	bl timer_idle
	b stop

linhaA: .space 100
