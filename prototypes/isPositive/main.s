#
# Program name: main.s - tests isPositive function
# Author: Portia Stevenson
# Date: 7/28/2025
# Purpose: Given an integer, this function determines whether the 
# the integer is positive, and returns a Boolean value indicating 
# accordingly: 1 if the number is positive, and 0 if the number is 
# not positive.  
# 


.text
.global main

main: 
  # Program dictionary:
  # r4 - user-entered input number
  # r5 - Boolean indicating whether positive or not
  # r8 - temporary storage for calculations
  # r0 and r1 - function arguments and results
  # r2 and r3 - temporary storage for calculations

  # push the stack
  SUB sp, sp, #4  
  STR lr, [sp]

  # Prompt user for input 
  LDR r0, =prompt1
  BL printf

  # Scanf/read in user input
  LDR r0, =formatString
  LDR r1, =num
  BL scanf
  
  LDR r0, =num
  LDR r0, [r0]
  MOV r4, r0 		// user input in r4

  # Check if user number is a positive number
  MOV r0, r4
  BL isPositive
  MOV r5, r0        	// isPositive in r5 (1 if true, else 0)

  # If user number is positive (i.e. r5 = 1)
  #   print outputPos
  #   else:
  #     print outputNotPos
  CMP r5, #1
  BNE else
    LDR r0, =outputPos
    MOV r1, r4
    BL printf
    B exit_isPos

  else:
    LDR r0, =outputNotPos
    MOV r1, r4
    BL printf

  exit_isPos:
    # Pop the stack and return to the OS
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr

.data
  prompt1: .asciz "\nEnter number: "
  formatString: .asciz "%d"
  num: .word 0
  outputPos: .asciz "Your number %d is positive.\n\n"
  outputNotPos:  .asciz "Your number %d is not positive.\n\n"

# END OF main

