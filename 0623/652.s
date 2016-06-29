.text
    .globl main

main:
    adr r0, array             @ endereco da lista
    mov    r1, #5                @ tamanho do array
    
    stmfd r13!, {r2-r12,r14}         @ faz o push dos registradores na pilha
    mov    r4, r1                @ contador no loop interno intera ateh n    
    sub    r9, r1, #1            @ tamanho do array -1, contador do loop externo itera ateh n-1
 
loop_externo:
    mov r5, r0                @ volto com o valor do endereço inicial para r5
    mov r4, r1                @ volto com o valor do contador para r4 para o tamanho do array
loop_interno:
    ldr r6, [r5], #4            @ carrego em r6 o primeiro elemento e incremento endereco
    ldr r7, [r5]                @ carrego o segundo elemento
    cmp r7, r6                @ comparo r7 e r6
    
    strls r6, [r5]            @ se eh menor carrego o que esta no endereco [r5] em r6
    strls r7, [r5, #-4]            @ e r7 recebe o que estava no outro registrador
 
    subs r4, r4, #1            @ diminui o contador interno e seta S
    bne    loop_interno    
 
    subs r9, r9, #1            @ diminui o contador externo e seta S
    bne    loop_externo
 
    ldmfd r13!, {r2-r12,r14}         @ volta os valores nos registradores

end:
    swi    0x123456            @ fim do programa
    
array:
    .word    0,1,4,3,2