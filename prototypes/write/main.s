# Program Name: main
# Author:	Brian Astrove
# Date:		Aug 3, 2025
# Purpose:	Main function to test the write function
# NOTE: 	scanf only reads one word. The write function will work beyond one 
#		word, but this main function can only send one word to it

.text
.global main
.extern write
main:
    #push the stack
    SUB sp, sp, #4
    STR lr, [sp]

    #Prompt user to enter filepath to write to
    LDR r0, =promptWrite
    BL printf
    LDR r0, =formatString
    LDR r1, =writePath
    BL scanf
    LDR r4, =writePath  //load value in r4

    #Prompt user to enter string to write to file
    LDR r0, =promptString
    BL printf
    LDR r0, =formatString
    LDR r1, =valueString
    BL scanf
    LDR r5, =valueString  //load value in r5

    MOV r0, r4
    MOV r1, r5

    #call write
    BL write


    #pop the stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr

.data
    output: .asciz "\n\n"
    formatString: .asciz "%s"
    promptWrite: .asciz "Enter filepath to write to: "
    //writePath: .word 0   
    promptString: .asciz "Enter string to print: "
    //valueString: .word 0   

.bss
    writePath: .space 256
    valueString: .space 256



