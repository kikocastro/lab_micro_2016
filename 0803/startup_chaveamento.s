.global _start
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

_Reset:
    bl main
    b .
undefined_instruction:
    b .
software_interrupt:
    b do_software_interrupt @vai para o handler de interrupções de software
prefetch_abort:
    b .
data_abort:
    b .
not_used:
    b .
irq:
    b do_irq_interrupt @vai para o handler de interrupções IRQ
fiq:
    b .
do_software_interrupt: @Rotina de Interrupçãode software
    add r1, r2, r3 @r1 = r2 + r3
    SUB r14, r14, #4
    mov pc, r14 @volta p/ o endereço armazenado em r14

do_irq_interrupt: @Rotina de interrupções IRQ


    SUB r14, r14, #4
    stmfd sp!, {r14}
    msr cpsr_c, 0xD3
    stmfd   sp!, {r14}
    adr r14, linhaA
    stmfa r14!, {R0-R12, sp}
    mrs r0, spsr
    stmfa r14!, {r0}
    mov r0, r14
    ldmfd sp!, {r14}
    stmfa r0!, {r14}
    msr cpsr_c, 0x53 

    LDR r0, INTPND @Carrega o registrador de status de interrupção
    LDR r1, [r0]
    TST r1, #0x0010 @verifica se é uma interupção de timer
    BLNE handler_timer @vai para o rotina de tratamento da interupção de timer
    LDMFD sp!,{R0-R12,pc}^

handler_timer:
    LDR r0, TIMER0X
    MOV r1, #0x0
    STR r1, [r0] @Escreve no registrador TIMER0X para limpar o pedido de interrupção
    @Inserir código que sera executado na interrupção de timer aqui (chaveamento de processos, ou alternar LED por exemplo)
    bl print_2

    adr r0, linhaA
    ldmfa r0!, {r14}
    stmfd sp!, {r14}
    mov r14, r0
    ldmfa r14!, {r0}
    msr spsr, r0
    ldmfa r14!, {r0-r12, sp}
    ldmfd sp!, {r14}
    ldmfa r14!, {pc}^


timer_init:
    mrs r0, cpsr
    bic r0,r0,#0x80
    msr cpsr_c,r0 @enabling interrupts in the cpsr
    LDR r0, INTEN
    LDR r1,=0x10 @bit 4 for timer 0 interrupt enable
    STR r1,[r0]
    LDR r0, TIMER0C
    LDR r1, [r0]
    MOV r1, #0xA0 @enable timer module
    STR r1, [r0]
    LDR r0, TIMER0V
    MOV r1, #0xff @setting timer value
    STR r1,[r0]
    mov pc, lr

main:
    LDR r13, =0x3000
    MSR CPSR_c, #0xD2
    LDR r13, =0x2000
    MSR CPSR_c, #0xD3
    bl hello
    bl timer_init @initialize interrupts and timer 0

parar:
    bl print_1
    b parar

linhaA:
    .space 1024
