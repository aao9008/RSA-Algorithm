#
# Program name: main.s - to test totient function
# Author: Portia Stevenson
# Date: 7/8/2025
# Purpose: Given input integers p and q, this function calculates 
# and returns the totient. 
# The formula used to calculate the totient is:  Φ(n) = (p - 1)(q - 1)
# 


.text
.global main

main: 

  # push the stack
  SUB sp, sp, #4  
  STR lr, [sp, #0]

  # Prompt for first input (p)
  LDR r0, =prompt1
  BL printf

  # Scanf/read in user input for p
  LDR r0, =formatString
  LDR r1, =p
  BL scanf

  # Prompt for second input (q)
  LDR r0, =prompt2
  BL printf

  # Scanf/read in user input for q
  LDR r0, =formatString
  LDR r1, =q
  BL scanf

  # Calculate totient
  LDR r0, =p
  LDR r0, [r0]
  LDR r1, =q
  LDR r1, [r1]
  BL totient
  MOV r4, r0        	// totient in r4

  # Print the output
  LDR r0, =output
  MOV r1, r4
  BL printf

  # Pop the stack and return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
  prompt1:  .asciz "\nEnter first number (p): "
  prompt2:  .asciz "Enter second number (q): "
  formatString:  .asciz "%d"
  p:  .word 0
  q:  .word 0
  output:  .asciz "The totient value is %d.\n\n"

# End main

