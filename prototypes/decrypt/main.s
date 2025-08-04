#
# Program name: main - for testing decrypt function
# Author: Portia Stevenson
# Date: 8/4/2025
# Purpose: Tests the decrypt function by prompting the user for ciphertext value c,
# private key exponent d, and modulus n, then calling decrypt to process encrypted.txt
# and write decrypted characters to plaintext.txt.
#
# Inputs:
#    - c: ciphertext value, entered by user
#    - d: private key exponent, entered by user
#    - n: modulus, entered by user
# Output:
#    - None: decrypt function writes output to plaintext.txt
#
# Algorithm:
#   Prompt user for ciphertext value c
#   Read c
#   Prompt user for private key exponent d
#   Read d
#   Prompt user for modulo n
#   Read n
#   Call decrypt function with c, d, n and return
#   

.text
.global main

main:
  # Program dictionary:
  # r4 - ciphertext value c
  # r5 - private key exponent d
  # r6 - modulus n
  # r0, r1 - function parameter arguments and results
  # r2, r3 - temp used for calculations

  # Push the stack
  SUB sp, sp, #16
  STR lr, [sp, #0]
  STR r4, [sp, #4]
  STR r5, [sp, #8]
  STR r6, [sp, #12]

  # Prompt for ciphertext value c
  LDR r0, =promptC
  BL printf

  # Read c
  LDR r0, =formatString
  LDR r1, =ciphertext
  BL scanf
  LDR r1, =ciphertext
  LDR r4, [r1]		// c in r4

  # Prompt for private key exponent d
  LDR r0, =promptD
  BL printf

  # Read d
  LDR r0, =formatString
  LDR r1, =exponent
  BL scanf
  LDR r1, =exponent
  LDR r5, [r1]		// d in r5

  # Prompt for modulo n
  LDR r0, =promptN
  BL printf

  # Read n
  LDR r0, =formatString
  LDR r1, =modulo
  BL scanf
  LDR r1, =modulo
  LDR r6, [r1]		// n in r6

  # Call decrypt function
  MOV r0, r4		// c in r0
  MOV r1, r5		// d in r1
  MOV r2, r6		// n in r2
  BL decrypt

  # Pop the stack and return to OS
  LDR lr, [sp, #0]
  LDR r4, [sp, #4]
  LDR r5, [sp, #8]
  LDR r6, [sp, #12]
  ADD sp, sp, #16
  MOV pc, lr

.data
  promptC:  .asciz "\nEnter ciphertext value c: "
  promptD:  .asciz "\nEnter private key exponent d: "
  promptN:  .asciz "\nEnter modulus n: "
  formatString:  .asciz "%d"
  ciphertext:  .word 0
  exponent:  .word 0
  modulo:  .word 0

# END OF main
