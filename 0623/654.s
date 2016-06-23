   .text
    .globl main

main:
    LDR r0, =4                @ tipo de dado: 1 eh Byte, 2 eh Half-word, 3 eh Word
    LDR r1, =0xABCD            @ valor a ser pushado
    MOV r10, #10            @ valor arbitrario para r10
    B push                @ vamos para a rotina de push
end:      
        SWI 0x123456            @ fim do programa
push:
    CMP r0, #1                @ se for Byte
    STREQB r1, [r13, #-4]!         @ salvamos em r13 - 4 caso seja Byte
    CMP r0, #2                @ se for HF
    STREQH r1, [r13, #-4]!         @ salvamos em r13 - 4 caso seja Half-Word
    CMP r0, #4                @ se for Word
    STREQ r1, [r13, #-4]!     @ salvamos em r13 - 4 caso seja Word
    LDR r3, [r13]            @ salvamos em r3 o que esta na memoria
    CMP r3, r1             @ comparamos r3 com r1
    MOVEQ r10, #0            @ se for igual, salvamos 0 em r10
    B end                @ terminamos o programa