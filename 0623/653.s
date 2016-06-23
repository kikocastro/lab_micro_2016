.text
           .globl main

main:
            ADR    r0, square    @ matriz
            MOV    r1, #3        @ N
            MOV    r9, #1        @ 1 para magico e 0 para nao magico

            @r2 com valor auxiliar
            MUL    r2, r1, r1
            ADD    r2, r2, #1
            MUL    r11, r2, r1
            MOV    r2, r11, LSR #1

            @linhas
            MOV    r4, #0            @ i
loopl:    MOV    r3, #0                @ soma linha
            MOV    r5, #0            @ j
loopli:   STMFD  r13!, {r4, r5}    
            BL        soma
            ADD    r5, r5, #1
            CMP    r5, r1
            BMI    loopli
            BL     check
            ADD    r4, r4, #1
            CMP    r4, r1
            BMI    loopl

        @colunas
            MOV    r5, #0
loopc:   MOV    r3, #0
            MOV    r4, #0
loopci:  STMFD  r13!, {r4, r5}
            BL     soma
            ADD    r4, r4, #1
            CMP    r4, r1
            BMI    loopci
            BL     check
            ADD    r5, r5, #1
            CMP    r5, r1
            BMI    loopc

        @diagonal principal
            MOV    r3, #0
            MOV    r4, #0
loopd1:  MOV    r5, r4
            STMFD  r13!, {r4, r5}
            BL     soma
            ADD    r4, r4, #1
            CMP    r4, r1
            BMI    loopd1
            BL     check

            @diagonal secundaria
            MOV    r3, #0
            MOV    r4, #0
loopd2: MOV    r5, r1
            SUB    r5, r5, #1
            SUB    r5, r5, r4
            STMFD  r13!, {r4, r5}
            BL     soma
            ADD    r4, r4, #1
            CMP    r4, r1
            BMI    loopd2
            BL     check
b_swi:            
        SWI    12345

@soma ao total
soma:
            LDMFD  r13!, {r10, r11}
            MUL       r12, r11, r1      
            ADD    r12, r12, r10
            LDR    r12, [r0, r12, LSL#2]
            ADD    r3, r3, r12
            MOV    pc, lr

@coloca 0 em r9 caso a soma nao seja igual
check:  CMP    r3, r2
            MOVNE  r9, #0
            MOV    pc, lr

@vetor
square:
    .word 2, 7, 6, 9, 5, 1, 4, 3, 8

    @2, 7, 6, 9, 5, 1, 4, 3, 1 nao magico    
    @16, 3, 2, 13, 5, 10, 11, 8, 9, 6, 7, 12, 4, 15, 14, 1 magico 4x4