# Program Name: Prime
# Author:	Brian Astrove
# Date:		July 20, 2025
# Purpose:	Find if integer is prime

.text
.global Prime
.global loop
.extern __aeabi_idiv
 
Prime:
    #push the stack
    SUB sp, sp, #4
    STR lr, [sp]

    #Number expected in r0
    MOV r6, r0

    CMP r6, #2 //check if n<2
    BLT NotPrime

    MOV r4, #2

loop:
    MUL r3, r4, r4
    CMP r3, r6
    BGT IsPrime //checks if at i^2

    MOV r0, r6
    MOV r1, r4
    BL __aeabi_idiv
    MOV r5, r0
    MUL r3, r5, r4
    CMP r3, r6
    BEQ NotPrime //if no remainder, they're divisible and its not prime

    ADD r4, r4,#1

    B loop

IsPrime:
    MOV r0, #1
    B Done

NotPrime:
    MOV r0, #0
    B Done

Done:
    #pop the stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr


#END Prime
