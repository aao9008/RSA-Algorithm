#
# Program Name: libMod.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/25/2025
# Purpose:
#   This file contains utility function for performing the mod operator.
#   These functions are intended to be called from a main driver program.
#
# Functions:
#   - mod:   Computes the remainder of help her
#
# Inputs:
#   r0 - the dividend
#   r1 - the divisor
#
# Outputs:
#   r0 - The remainder from dividing r0 / r1
#
# Pseudo Code: 
#   void int mod(int x, int y) {
#       int quotient = x / y;
#       int product = x * y;
#       int remainder = x - product;
#
#       // Fix for negative remainder
#       if (remainder < 0){
#           remainder = remainder + y;
#       }
#
#       return remainder;
#   }
.text
.global mod
mod:
    # Push the stack
    SUB sp, sp, #20
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #20]

    # Copy passed arguments into r4 and r5
    MOV r4, r0 @ r4 <- dividend
    MOV r5, r1 @ r5 <- divisor

    # Perform division (r0 - dividend, r1 - divisor)
    BL __aeabi_idiv @ r0 <- r0 / r1

    # Store result of divsion function
    MOV r6, r0 @ r6 <- r0 (result)

    # Get the product of the dividend and divisor
    MUL r7, r4, r5

    # Subtract the product from the dividend to get the remainder
    SUB r0, r4, r7

    # Fix for negative remainder
    CMP r0, #0 @ if remainder <0
    ADDLT r0, r0, r5 @ then add divisor

    # Pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #20]
    ADD sp, sp, #20
    MOV pc, lr
# END mod

