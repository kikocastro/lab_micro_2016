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
	pid:
		.word 0  @inicializa rotina atual 

	@Tratamento de Interrupcoes
	_Reset:
		LDR r13, = 0x1000

		MRS r0, CPSR_all
		BIC r0, r0, #0x1F
		ORR R0, R0, #0b10010 @ vai para modo IRQ (interrupt)
		MSR CPSR_all, r0

		LDR r13, = 0x2000

		MRS r0, CPSR_all
		BIC r0, r0, #0x1F
		ORR R0, R0, #0b10011 @ volta para svc
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

		STMFD sp!, {r12}		 @guarda r12 na pilha
		
		@ define qual eh a rotina atual
		LDR r12, =pid
		LDR r12, [r12]
		CMP r12, #0
		LDREQ r12, =linhaA
		CMP r12, #1
		LDREQ r12, =linhaB
		CMP r12, #2
		LDREQ r12, =linhaC

		@ INICIO EMPILHA
		SUB lr, lr, #4			@corrigimos LR (para pegar o valor de pc antigo a ser salvo depois)

		STMIA r12!, {r0-r11}	 @guarda registradores r0-r11 na linhaA
		MOV r7, r12              @passa endereco da proxima posicao de linhaA vazia para r7
		LDMFD sp!, {r12}		 @retira valor original de r12 da pilha
		STR r12, [r7], #4		 @guarda r12 na linhaA e avanca topo da pilha em r7

		MRS r6, SPSR				@guardamos o modo anterior em r6 (SPSR indica o modo anterior de CPSR)

		LDR r0, TIMER0X
		LDR r1, =0
		STR r1, [r0]				@abaixamos a interrupção
		
		@ vai pra modo supervisor
		MRS r0, CPSR_all
		BIC r0, r0, #0x1F			@limpa os bits de modo
		ORR R0, R0, #0b10011 		@guarda o modo supervisor
		MSR CPSR_all, r0 			@salva em cpsr
		@MODO SUPERVISOR
		STMIA r7!, {sp, lr}		@empilhamos sp e lr do modo supervisor

		@ volta pra modo irq
		MRS r0, CPSR_all			
		BIC r0, r0, #0x1F			@limpa os bits de modo
		ORR R0, R0, #0b10010		@guarda o modo irq
		MSR CPSR_all, r0			@salva em cpsr
		@ MODO IRQ
		STR lr, [r7], #4       @ guardamos pc antigo e avancamos o topo
		STR r6, [r7] 			@botamos na pilha (nosso SPSR -> CPSR da linhaA)
		@ FIM DE EMPILHA

	desempilha:
		@recupera registradores antes de acabar a interrupção
		MOV r1, #0
		MOV r2, #1
		MOV r3, #2

		LDR r11, =pid		
		LDR r12, [r11]			@Pega valor do pid atual

		CMP r12, #0 			@Verifica se era o processo 0 rodando
		LDREQ r0, =linhaB		@Se sim, vamos restaurar registradores do processo 1
		STREQ r2, pid	@Então, coloca pid = 1

		CMP r12, #1 			@Verifica se era o processo 1 rodando
		LDREQ r0, =linhaC		@Se sim, vamos restaurar registradores do processo 2
		STREQ r3, pid	@Então, coloca pid = 0

		CMP r12, #2 			@Verifica se era o processo 2 rodando
		LDREQ r0, =linhaA		@Se sim, vamos restaurar registradores do processo 0
		STREQ r1, pid	@Então, coloca pid = 0

		@desempilha
		ADD r1, r0, #64			@vamos para o final da linhaB (r1 eh o topo da linhaB)
		LDR r2, [r1], #-12       @carrega em r2 o cpsr guardado e abaixa o topo da linhaB r1 para sp
		MSR spsr, r2 		 @coloca o cpsr guardado em spsr

		@ vai pra modo supervisor
		MRS r0, CPSR_all			
		BIC r0, r0, #0x1F			@limpa os bits de modo
		ORR R0, R0, #0b10011 		@guarda o modo supervisor
		MSR CPSR_all, r0 			@salva em cpsr
		@ modo SUPERVISOR
		LDMIA r1, {sp, lr}		@salvamos de linhaB sp e lr do modo supervisor
		
		@ volta pra modo irq
		MRS r0, CPSR_all
		BIC r0, r0, #0x1F			@limpa os bits de modo
		ORR R0, R0, #0b10010		@guarda o modo irq
		MSR CPSR_all, r0			@salva em cpsr
		@ MODO IRQ
	
		SUB r13, r1, #52 @movemos ponteiro da linha para inicio

		LDMIA r13!, {r0-r12}  @desempilha o resto dos registradores
		ADD r13, r13, #8       @ avanca ponteiro para r15
		LDMIA r13, {pc}^	@carrega pc e volta para o modo anterior

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
	B rotinaA

linhaA:
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x2000, 0, rotinaA, 0b00010011, 0, 0, 0, 0, 0, 0, 0

linhaB:
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x3000, 0, rotinaB, 0b00010011, 0, 0, 0, 0, 0, 0, 0

linhaC:
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x4000, 0, rotinaC, 0b00010011, 0, 0, 0, 0, 0, 0, 0
