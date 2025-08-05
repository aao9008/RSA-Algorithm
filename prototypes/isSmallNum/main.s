#
# Program name: main.s - to test isSmallNum
# Author: Portia Stevenson
# Date: 7/28/2025
# Purpose: Given an integer, this function determines whether the 
# the integer is as small number (less than 50), and returns a Boolean 
# value indicating accordingly: 
# 1 if the number is small, and 0 if the number is not small.  
# 


.text
.global main

main: 
  # Program dictionary: 
  # r4 - user-entered input number
  # r5 - Boolean indicating whether small number or not
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

  # Check if user number is a small number
  MOV r0, r4
  BL isSmallNum
  MOV r5, r0        	// isSmallNum in r5 (1 if true, else 0)

  # If user number > 50 (i.e. r5 > 50)
  #   print output is a small number (outputSmall)
  #   else:
  #     print output is not a small number (outputNotSmall)
  CMP r5, #1
  BNE else
    LDR r0, =outputSmall
    MOV r1, r4
    BL printf
    B end_ProgIsSmallNum

  else:
    LDR r0, =outputNotSmall
    MOV r1, r4
    BL printf

  end_ProgIsSmallNum:
    # Pop the stack and return to the OS
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr

.data
  prompt1: .asciz "\nEnter number: "
  formatString: .asciz "%d"
  num: .word 0
  outputSmall: .asciz "Your number %d is a small number.\n\n"
  outputNotSmall:  .asciz "Your number %d is not a small number.\n\n"

# END OF main

