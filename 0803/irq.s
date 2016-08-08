			.global _start
			.text
			_start:

	@Vetor de Interrupcoes
			b _Reset						              @posição 0x00  - Reset
			ldr pc, _undefined_instruction	  @posição 0x04  - Intrução não definida
			ldr pc, _software_interrupt		    @posição 0x08  - Interrupção de Software
			ldr pc, _prefetch_abort		      	@posição 0x0C  - Prefetch Abort
			ldr pc, _data_abort			         	@posição 0x10  - Data Abort
			ldr pc, _not_used			           	@posição 0x14  - Não utilizado
			ldr pc, _irq					            @posição 0x18  - Interrupção(IRQ)
			ldr pc, _fiq					            @posição 0x1C  - Interrupção(FIQ)

	_undefined_instruction: 
		.word undefined_instruction
	_software_interrupt: 
		.word software_interrupt
	_prefetch_abort: 
		.word prefetch_abort
	_data_abort: 
		.word data_abort
	_not_used: 
		.word not_used
	_irq: 
		.word irq
	_fiq: 
		.word fiq
		
	@Valores Constantes
	INTPND:
		.word 0x10140000 @Interrupt status register
	INTSEL:
		.word 0x1014000C @interrupt select register( 0 = irq, 1 = fiq)
	INTEN:
		.word 0x10140010 @interrupt enable register
	TIMER0L:
		.word 0x101E2000 @Timer 0 load register
	TIMER0V:
		.word 0x101E2004 @Timer 0 value registers
	TIMER0C:
		.word 0x101E2008 @timer 0 control register
	TIMER0X:
		.word 0x101E200c @timer 0 interrupt clear register
	ROTINA_ATUAL:
		.word 0x0300008  @rotina atual

	@Tratamento de Interrupcoes
	_Reset:
		LDR r13, = 0x1000

		MRS r0, CPSR_all
		BIC r0, r0, #0x1F
		ORR R0, R0, #0b10010
		MSR CPSR_all, r0

		LDR r13, = 0x2000

		MRS r0, CPSR_all
		BIC r0, r0, #0x1F
		ORR R0, R0, #0b10011
		MSR CPSR_all, r0
		bl  main
		b .
	
	undefined_instruction:
		b .
	
	software_interrupt:
		b   do_software_interrupt 	@vai para o handler de interrupções de software
	
	prefetch_abort:
		b .
	
	data_abort:
		b .
	
	not_used:
		b .
	
	irq:
		b   do_irq_interrupt 		@vai para o handler de interrupções IRQ
	
	fiq:
		b .
	
	do_software_interrupt:			@Rotina de Interrupção de software
		add r1, r2, r3				@r1 = r2 + r3
		mov pc, r14					@volta p/ o endereço armazenado em r14
	
	do_irq_interrupt:				@Rotina de interrupções IRQ

		LDR r12, ROTINA_ATUAL		@salvamos endereço da rotina atual
		LDR r12, [r12]				@carregamos o que ta no endereço
		SUBS r12, #1				@tiramos 1 para ver onde estamos A=1 B=0
		BPL do_B					@se >= 0  vamos pro B
	
	do_A:
		ADR r12, linhaA				@carrega endereço de linhaA em r12
		SUB r14, r14, #4			@corrigimos LR
		STMEA r12!, {r0-r11, lr}	@botamos na linhaA os regs

		MRS r0, SPSR				@guardamos o modo anterior em r0 (SPSR indica o modo anterior de CPSR)
		STMEA r12!, {r0}			@botamos na pilha (nosso SPSR -> CPSR da linhaA)

		LDR r0, ROTINA_ATUAL
		LDR r1, =1
		STR r1, [r0]				@atualizamos rotina atual para A

		LDR r0, TIMER0X
		LDR r1, =0
		STR r1, [r0]				@abaixamos a interrupção
		
		MRS r0, CPSR_all
		BIC r0, r0, #0x1F			@limpa os bits de modo
		ORR R0, R0, #0b10011 		@guarda o modo supervisor
		MSR CPSR_all, r0 			@salva em cpsr

		STMEA r12!, {sp, lr}		@empilhamos sp e lr

		MRS r0, CPSR_all			
		BIC r0, r0, #0x1F			@limpa os bits de modo
		ORR R0, R0, #0b10010		@guarda o modo irq
		MSR CPSR_all, r0			@salva em cpsr
		
		ADR r12, linhaB				@carrega endereço da linhaB
		ADD r12, r12, #64			@vamos para o final da linha

		MRS r0, CPSR_all			
		BIC r0, r0, #0x1F			@limpa os bits de modo
		ORR R0, R0, #0b10011 		@guarda o modo supervisor
		MSR CPSR_all, r0 			@salva em cpsr

		LDMEA r12!, {sp, lr}		@salvamos em linhaB sp e lr
		
		MRS r0, CPSR_all
		BIC r0, r0, #0x1F			@limpa os bits de modo
		ORR R0, R0, #0b10010		@guarda o modo irq
		MSR CPSR_all, r0			@salva em cpsr

		LDMEA r12!, {r0}
		MSR SPSR, r0 					
		LDMEA r12!, {r0-r11, pc}^	@termina de desempilhar e volta para o modo anterior

	do_B:
		ADR r12, linhaB
		SUB r14, r14, #4
		STMEA r12!, {r0-r11, lr}

		MRS r0, SPSR
		STMEA r12!, {r0}

		LDR r0, ROTINA_ATUAL
		LDR r1, =0
		STR r1, [r0]

		LDR r0, TIMER0X
		LDR r1, =0
		STR r1, [r0]
		
		MRS r0, CPSR_all
		BIC r0, r0, #0x1F
		ORR R0, R0, #0b10011
		MSR CPSR_all, r0

		STMEA r12!, {sp, lr}

		MRS r0, CPSR_all
		BIC r0, r0, #0x1F
		ORR R0, R0, #0b10010
		MSR CPSR_all, r0		

		ADR r12, linhaA
		ADD r12, r12, #64

		MRS r0, CPSR_all
		BIC r0, r0, #0x1F
		ORR R0, R0, #0b10011
		MSR CPSR_all, r0

		LDMEA r12!, {sp, lr}
		
		MRS r0, CPSR_all
		BIC r0, r0, #0x1F
		ORR R0, R0, #0b10010
		MSR CPSR_all, r0

		LDMEA r12!, {r0}
		MSR SPSR, r0
		LDMEA r12!, {r0-r11, pc}^		

	timer_init:
		LDR r0, INTEN
		LDR r1,=0x10 			@bit 4 for timer 0 interrupt enable
		STR r1,[r0]
		LDR r0, TIMER0C
		LDR r1, [r0]
		MOV r1, #0xA0 			@enable timer module
		STR r1, [r0]
		LDR r0, TIMER0V 
		LDR r1, =0x1 			@setting timer value
		STR r1,[r0]
		mrs r0, cpsr
		bic r0,r0,#0x80
		msr cpsr_c,r0			@enabling interrupts in the cpsr
		mov pc, lr
		
	/*############### main ###############*/
		
main:
	bl c_entry
	bl timer_init @initialize interrupts and timer 0
	LDR r0, ROTINA_ATUAL
	LDR r1, =0
	STR r1, [r0]
	B rotinaA

linhaA:
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, rotinaA, 0b00010011, 0x2000, 0, 0, 0, 0, 0, 0, 0

linhaB:
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, rotinaB, 0b00010011, 0x3000, 0, 0, 0, 0, 0, 0, 0
