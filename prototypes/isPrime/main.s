# Program Name: main.s
# Author:	Brian Astrove
# Date:		July 29, 2025
# Purpose:	Main function to test the isPrime function

.text
.global main
.extern isPrime
main:
    #push the stack
    SUB sp, sp, #4
    STR lr, [sp]

    #Prompt user to enter value
    LDR r0, =prompt
    BL printf
    LDR r0, =formatString
    LDR r1, =value
    BL scanf

    LDR r6, =value
    LDR r0, [r6]  //load value in r0

    #call isPrime
    BL isPrime

    #Print
    CMP r0, #1
    BNE NotPrime
        #Is prime function block to print it's prime
        LDR r0, =outputPrime 
        BL printf
        B Done
    NotPrime:
       # not prime block to print its not prime 
       LDR r0, =outputNotPrime
        BL printf
        B Done
    Done:

    #pop the stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr

.data
    outputPrime: .asciz "\nThe value is prime\n"
    outputNotPrime: .asciz "\nThe value is not prime\n"
    formatString: .asciz "%d"
    prompt: .asciz "Enter value: "
    value: .word 0
    

