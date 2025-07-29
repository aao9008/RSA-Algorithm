# Program Name: isPrime
# Author:	Brian Astrove
# Date:		July 29, 2025
# Purpose:	A utility function to determine if integer is prime
# External dependencies: __aeabi_idiv
# 
# Functions: isPrime determines if integer is prime
# 
# Inputs: 
#  r0 - the number to evaluate if its prime
#  
# Outputs:
#  r0 - a boolean result: 0 = not prime, 1 = prime
#  
# Pseudo code: 
#  if int n <= 1: return False
#  for i in range(2, sqrt(n) +1):
#    if n % i == 0
#      Return False
#  Return True
# 
#  Why this works:
#    2 is the first real prime number
#    suppose n = a x b. If both a and b are greater than sqrt(n), then a x b > n, which is not a valid case.
#    so if n has any divisors, at lease of of them must be less or equal to sqrt(n)
# 
.text
.global isPrime
.extern __aeabi_idiv
 
isPrime:
    # push the stack
    SUB sp, sp, #16
    STR lr, [sp]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    # number expected in r0, store in r6
    MOV r6, r0

    # check if n < 2, and thus not prime
    CMP r6, #2
    BLT NotPrime

    MOV r4, #2

loop:
    # checks if loop has reached i^2 which determines the number is prime
    MUL r3, r4, r4
    CMP r3, r6
    BGT Prime 

    # divides the input by current loop index
    # if no remainder, the number is evenly divisible and the input is determined not prime
    MOV r0, r6
    MOV r1, r4
    BL __aeabi_idiv
    MOV r5, r0
    MUL r3, r5, r4
    CMP r3, r6
    BEQ NotPrime

    # add 1 to the index and run the loop again
    ADD r4, r4,#1
    B loop

Prime:
    # if prime, set r0 to 1
    MOV r0, #1
    B Done

NotPrime:
    # if not prime, set r0 to 0
    MOV r0, #0
    B Done

Done:
    #pop the stack
    LDR lr, [sp]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]   
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr

#END isPrime
