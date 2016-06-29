.text
        .globl main
main:
    MOV        r1, #100             @dividendo
    MOV        r2, #7               @divisor
    BL         divide
    SWI     0x123456

divide:
    CMP        r2, #0               @verifica se a divisão é por zero
    BEQ        divide_end

    MOV        r3, #0               @quociente
    MOV        r4, #1               @quociente temporário

setup:
    CMP         r2, r1              @verifica se dividendo é maior que divisor
    MOVLS       r2, r2, LSL #1      @caso seja, multiplica divisor por 2
    MOVLS       r4, r4, LSL #1      @multiplica por 2 quociente temporário tbm
    BLS         setup
    

next:
    CMP       r1, r2                @verifica qm é maior
    SUBCS     r1, r1, r2            @se dividendo > divisor, dividendo - divisor
    ADDCS     r3, r3, r4            @portanto, coloca no quociente

    MOVS      r4, r4, LSR #1        @e divide os 2 para verificar se ainda "cabe" no dividendo
    MOVS      r2, r2, LSR #1
    
    BCC       next

divide_end:
    MOV         r5 ,r1              @r5 = resto
    MOV         pc, r14