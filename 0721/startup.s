.section INTERRUPT_VECTOR, "x"
.global _Reset
_Reset:
  B Reset_Handler /* Reset */
  B Undefined_Handler /* Undefined */
  B . /* SWI */
  B . /* Prefetch Abort */
  B . /* Data Abort */
  B . /* reserved */
  B . /* IRQ */
  B . /* FIQ */
 
Reset_Handler:
  LDR r13, = 0x1000

  MRS r0, CPSR_all
  BIC r0, r0, #0x1F
  ORR R0, R0, #0b11011
  MSR CPSR_all, r0

  LDR r13, = 0x2000

  MRS r0, CPSR_all
  BIC r0, r0, #0x1F
  ORR R0, R0, #0b10011
  MSR CPSR_all, r0
  
  LDR sp, =stack_top
  BL c_entry
  .word 0xffffffff
  B .

Undefined_Handler:
  STMFD sp!,{R0-R12,lr}
  BL undefined
  LDMFD sp!,{R0-R12,pc}^