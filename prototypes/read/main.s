# Program Name: main (for read and write)
# Author:	Brian Astrove
# Date:		Aug 3, 2025
# Purpose:	Main function to test the read and write functions

.text
.global main
.extern read
main:
    #push the stack
    SUB sp, sp, #4
    STR lr, [sp]

    #Prompt user to enter filepath value
    LDR r0, =prompt
    BL printf
    LDR r0, =formatString
    LDR r1, =value
    BL scanf

    LDR r0, =value  //load value in r0

    #call read
    BL read

    #pop the stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr

.data
    output: .asciz "\n\n"
    formatString: .asciz "%s"
    prompt: .asciz "Enter filepath to read from: "
    value: .word 0

