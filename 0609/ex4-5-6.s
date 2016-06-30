      .text
      .globl main
main:
      MOV r0, #1              
      MOV r1, #17              
      MOV r10, #1             
      MOV r12, #2             
loop:
      CMP r1, r12             
      BMI end                 
      ADD r11, r0, r10        
      MOV r10, r0             
      MOV r0, r11             
      ADD r12, r12, #1        
      B   loop                
end:
      SWI 0x123456
