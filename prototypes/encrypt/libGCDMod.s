#
# Program Name: libGCDMod.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/25/2025
# Purpose:
#   This file contains utility functions related to modular arithmetic.
#   These functions are intended to be called from a main driver program
#   or other utility modules (e.g., RSA key generation).
#
# Functions:
#   - mod:   Computes the mathematical modulus (remainder) of two integers.
#   - gcd:   Computes the greatest common divisor of two integers using the Euclidean Algorithm.
#
# Inputs:
#   Varies by function — see individual function headers for register usage and purpose.
#
# Outputs:
#   Varies by function — see individual function headers for output registers and behavior.

# Function: mod
# Purpose: To compute the non-negative remainder of two signed integers.
#
# Input:
#   r0 - Dividend (numerator)
#   r1 - Divisor  (denominator)
#
# Output:
#   r0 - The non-negative remainder (r0 mod r1)
#
# Pseudo Code:
#   int mod(int x, int y) {
#       int quotient = x / y;
#       int product = quotient * y;
#       int remainder = x - product;
#       if (remainder < 0) {
#           remainder = remainder + y;
#       }
#       return remainder;
#   }
.text
.global mod
mod:
    # Program Dictionary 
    #   r4 - dividend
    #   r5 - divisor 
    #   r6 - quotient
    #   r7 - product of quotient and divisor 

    # Push the stack
    SUB sp, sp, #20
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]

    # Copy passed arguments into r4 and r5
    MOV r4, r0 @ r4 <- dividend
    MOV r5, r1 @ r5 <- divisor

    # Perform division (r0 - dividend, r1 - divisor)
    BL __aeabi_idiv @ r0 <- r0 / r1

    # Store result of divsion function
    MOV r6, r0 @ r6 <- r0 (result)

    # Get the product of the quotient and divisor
    MUL r7, r6, r5

    # Subtract the product from the dividend to get the remainder
    SUB r0, r4, r7

    # Fix for negative remainder
    CMP r0, #0 @ if remainder < 0
    ADDLT r0, r0, r5 @ then add divisor

    # Pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    ADD sp, sp, #20
    MOV pc, lr
# END mod

# Function: GCD
# Purpose: Computes the greatest common divisor of two integers using the Euclidean Algorithm.
#
# Input:  r0 - first integer (a)
#         r1 - second integer (b)
# Output: r0 - the greatest common divisor of a and b
#
# Pseudo Code:
#   int GCD(int a, int b) {
#       while (b != 0) {
#           int temp = b;
#           b = a % b;
#           a = temp;
#       }
#       return a;
#   }
.text
.global gcd
gcd:
    # Program Dictionary
    #   r4 - absolute value of first integer (a)
    #   r5 - absolut value of second integer (b)
    #   r6 - temporary value (temp)

    # Push the stack
    SUB sp, sp, #16
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    @ Ensure r0 is non-negative
    CMP r0, #0
    BGE skip_abs0
    RSBS r0, r0, #0 @ r0 = -r0
    skip_abs0:

    @ Ensure r1 is non-negative
    CMP r1, #0
    BGE skip_abs1
    RSBS r1, r1, #0 @ r1 = -r1
    skip_abs1:

    # Copy input arguments into preserved registers
    MOV r4, r0
    MOV r5, r1

    startGCDLoop:
        CMP r5, #0
        BEQ endGCDLoop @ if b == 0, exit loop

        MOV r6, r5 @ temp = b

        # Calculate a mod b (mod will use r0, r1 and return result in r0)
        MOV r0, r4
        MOV r1, r5
        BL mod

        MOV r4, r6 @ a = temp
        MOV r5, r0 @ b = a % b
        
        B startGCDLoop
    endGCDLoop:

    # Return the value of a (GCD)
    MOV r0, r4

    # Pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr
# END gcd





