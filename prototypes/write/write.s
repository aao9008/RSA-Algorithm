# Program Name: write
# Author:	Brian Astrove
# Date:		Aug 3, 2025
# Purpose:	A utility function to write as string to a file
# External dependencies: n/a
# 
# Functions: write takes in a string and prints to the filepath
# 
# Inputs: 
#  r0 - the filepath to print to
#  r1 - the string to print
# Outputs:
#  Prints the string to the filepath file
#  
# Pseudo code: 
# call syscall open
# call stnlen to determine string length
# call syscall write
#   
# Notes:
#    swi is a systems call
#    set r7 to syscall number:
#       5 = open
#       3 = read
#       4 = write
#       1 = exit
# 
#  
.text
.global write
write:
    # push the stack
    SUB sp, sp, #24
    STR lr, [sp]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]
    STR r8, [sp, #20]
    
    #save input data
    MOV r4, r0 	//file path
    MOV r6, r1  //string input

    #open the file
    MOV r2, #420
    #mode = if file created, owner can read/write, others only read
    LDR r3, =577
    #flags = open file to write, create if doesnt exist, overwrite ifdoes exist
    MOV r1, r3
    MOV r0, r4  //file path to r0
    MOV r7, #5	//syscall to open
    swi 0	//syscall 
    CMP r0, #0  
    BLT Fail	//if not contents, fail
    MOV r8, r0

    #find string length of input string
    MOV r0, r6	//point to string 
    BL strlen
    MOV r5, r0  //r5 = string length
    
    #write to file
    MOV r0, r8  //pointer to filepath
    MOV r1, r6  //pointer to string
    MOV r2, r5
    MOV r7, #4	//syscall write
    swi 0

    #close the file
    MOV r0, r4
    MOV r7, #6		//syscall close
    swi 0
    MOV r0, #0
    B Done

Fail:
    LDR r0, =outputFail
    BL printf
    B Done

Done:
    #pop the stack
    LDR lr, [sp]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]   
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    ADD sp, sp, #24
    MOV pc, lr

#END write

.data
    outputFail: .asciz "\nWrite failed.\n"

.text
.global strlen
strlen:
    # input: r0 = string pointer
    # output: r0 = length of string

    #push the stack
    SUB sp, sp, #12
    STR lr, [sp]
    STR r1, [sp, #4]
    STR r2, [sp, #8]   


    MOV r1, r0
strlen_loop:
    LDRB r2, [r0]	//loads a single register byte
    CMP r2, #0
    BEQ Done2
    ADD r0, r0, #1
    B strlen_loop

Done2:
    SUB r0, r0, r1 	//r0 = end - start
    #pop the stack
    LDR lr, [sp]
    LDR r1, [sp, #4]
    LDR r2, [sp, #8]   
    ADD sp, sp, #12
    MOV pc, lr


#End strlen
