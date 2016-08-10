.global _start
.global TIMER0X
.text

_start:
	b _Reset @posição 0x00 - Reset
	ldr pc, _undefined_instruction @posição 0x04 - Intrução não-definida
	ldr pc, _software_interrupt @posição 0x08 - Interrupção de Software
	ldr pc, _prefetch_abort @posição 0x0C - Prefetch Abort
	ldr pc, _data_abort @posição 0x10 - Data Abort
	ldr pc, _not_used @posição 0x14 - Não utilizado
	ldr pc, _irq @posição 0x18 - Interrupção (IRQ)
	ldr pc, _fiq @posição 0x1C - Interrupção(FIQ)
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


_Reset:
	LDR sp, =0x5000
  	MSR cpsr, 0b10010 @ vai para modo IRQ (interrupt)
  	LDR sp, =0x1000
  	MSR cpsr, 0b10011 @ volta para svc
	bl main
	b .

undefined_instruction:
	b .

software_interrupt:
	b do_software_interrupt  @vai para o handler de interrupções de software

 prefetch_abort:
 	b .

data_abort:
 	b .

not_used:
	b .

irq:
	LDR sp, =0x1000
	b do_irq_interrupt		 @vai para o handler de interrupções IRQ

fiq:
	b .

do_software_interrupt:	 	 @Rotina de Interrupçãode software
	add r1, r2, r3		 	 @r1 = r2 + r3
	mov pc, r14 			 @volta p/ o endereço armazenado em r14

do_irq_interrupt:			 @Rotina de interrupções IRQ
	STMFD sp!, {r12}		 @guarda r12 na pilha

	LDR r12, =pid
	LDR r12, [r12]
	CMP r12, #1
	LDREQ r12, =linhaA
	LDRNE r12, =linhaB

	SUB r14, r14, #4		@subtrai 4 de lr (para pegar o valor de pc antigo)
	@STMFD sp!, {r0 - r3, LR} @Empilha os registradores

	@save previous state
	STMIA r12!, {r0-r11}	 @guarda registradores r0-r11 na linhaA
	MOV r0, r12              @passa endereco da proxima posicao de memoria vazia para r0
	LDMFD sp!, {r12}		 @retira valor original de r12 da pilha
	STR r12, [r0], #4		 @guarda r12 na linhaA

	MRS r1, spsr 		     @copia spsr em r1
	MSR cpsr, 0b10010011 	 @ volta para svc, desabilitando as interrupções de tempo (I F T Mode), Mode: bits 4-0, T: state, F: fast interrupt, I: interrupt
	STMIA r0!, {sp, lr}	     @armazena lr e sp do modo supervisor
	MSR cpsr, 0b10010010     @vai para o modo irq
	STR r14, [r0], #4	 	 @armazena pc
	STR r1, [r0]			 @armazena cpsr anteriormente salvo
	@finished saving previous state

	LDR r0, INTPND 			 @Carrega o registrador de status de interrupção
	LDR r0, [r0]
	TST r0, #0x0010   		 @verifica se é uma interupção de timer
	BLNE handler_timer       @vai para o rotina de tratamento da interupção de timer

	@recupera registradores antes de acabar a interrupção
	MOV r1, #1
	MOV r2, #2

	LDR r12, =pid		
	LDR r12, [r12]			@Pega valor atual do process id
	CMP r12, #1				@Verifica se era o processo 1 rodando
	LDREQ r0, =linhaB		@Se sim, vamos restaurar registradores do processo B
	STREQ r2, pid			@Então, coloca pid = 2
	LDRNE r0, =linhaA		@Se não, vamos restaurar registradores do processo A
	STRNE r1, pid			@Então, coloca pid = 1

bk3:ADD r1, r0, #64
	LDR r2, [r1]
	MSR spsr, r2 		 @coloca o cpsr guardado em spsr

	MOV r13, r0
	MSR cpsr, 0b10010011 		 @vou para modo supervisor
	SUB r1, r1, #12		 		 @r1 apontava para cpsr; volta 3 para apontar para sp
	LDMIA r1, {r13-r14}
	MSR cpsr, 0b10010010     	 @vai para o modo irq
	LDMIA r13!, {r0-r12}	 		 @recupera cpsr, sp e lr
	ADD r13, r13, #8
	LDMIA r13, {r15}^
	@LDMFD sp!, {r0 - r3, pc}^ @retorna

timer_init:
	LDR r0, INTEN
	LDR r1,=0x10 			@bit 4 for timer 0 interrupt enable
	STR r1,[r0]
	LDR r0, TIMER0C
	LDR r1, [r0]
	MOV r1, #0xA0  			@enable timer module
	STR r1, [r0]
	LDR r0, TIMER0V
	ldr r1, =0x1  			@setting timer value
	STR r1,[r0]
	mrs r0, cpsr
	bic r0,r0,#0x80
	msr cpsr_c,r0 			@enabling interrupts in the cpsr
	mov pc, lr

main:
	bl c_entry				@chama a função em C que printa hello world
	@Inicializando processo A
	LDR r0, =linhaA
	ADD r0, r0, #52			@Pega ultimo endereco de linhaA
	LDR r1, =0x5000
	STR r1, [r0], #8
	LDR r1, =c_space 		@Pega endereco de c_space
	STR r1, [r0], #4
	LDR r1, =0b10011
	STR r1, [r0] 			@Guarda modo supervisor no cpsr do processo A			

	@Inicializando processo B
	LDR r0, =linhaB
	ADD r0, r0, #52			@Pega ultimo endereco de linhaA
	LDR r1, =0x3000
	STR r1, [r0], #8
	LDR r1, =c_asterisk 	@Pega endereco de c_space
	STR r1, [r0], #4	
	LDR r1, =0b10011
	STR r1, [r0] 			@Guarda modo supervisor no cpsr do processo B

	bl timer_init  			@initialize interrupts and timer 

stop: bl c_space 			@printa um espaço enquanto não ocorre uma interrupção


linhaA: .space 17*4 		@espaço na memória para o processo A: r0-r15, cpsr
linhaB: .space 17*4			@espaço na memória para o processo B: r0-r15, cpsr
pid:	.word 1				@processo inicial é o processo 1
