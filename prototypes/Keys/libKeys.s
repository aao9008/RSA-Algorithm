#
# Program Name: libKeys.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/30/2025
# Purpose:
#   This file contains utility functions for RSA key computation written in ARM Assembly.
#   It includes the implementation of the cprivexp function, which computes the private
#   key exponent d using the Extended Euclidean Algorithm.
#
# Functions:
#   - cprivexp:      Computes the modular inverse of e mod totient_value to produce d.
#
# Inputs:
#   Vary by function — see individual function headers for specific usage.
#
# Outputs:
#   Vary by function — see individual function headers for specific usage.
#

# Function: cprivexp
# Purpose: Compute the private key exponent `d` such that (d * e) ≡ 1 mod totient_value,
#          using the Extended Euclidean Algorithm.
#
# Input:   r0 - public exponent (e)
#          r1 - totient value of n (totient_value = (p - 1)(q - 1))
#
# Output:  r0 - private exponent (d), such that (d * e) mod totient_value = 1
#          Returns -1 if no modular inverse exists (i.e., e and totient_value are not coprime)
#
# Pseudo Code:
#   int cprivexp(int e, int totient_value) {
#       remainder_base = totient_value
#       divisor = e
#       old_inverse = 0
#       current_inverse = 1
#
#       while (divisor ≠ 0) {
#           quotient = remainder_base / divisor
#           remainder = remainder_base % divisor
#
#           temp_inverse = old_inverse - quotient * current_inverse
#           old_inverse = current_inverse
#           current_inverse = temp_inverse
#
#           remainder_base = divisor
#           divisor = remainder
#       }
#
#       if (remainder_base ≠ 1)
#           return -1   // e and totient_value not coprime
#
#       if (old_inverse < 0)
#           old_inverse = old_inverse + totient_value
#
#       return old_inverse  // this is d
#   }
.text
.global cprivexp
cprivexp:
    # Program Dictionary
    #   r4 - divisor (starts as public exponenet e)
    #   r5 - remainder_base (starts as totient value)
    #   r6 - old_inverse
    #   r7 - current_inverse
    #   r8 - temp_inverse
    #   r9 - quotient
    #   r10 - remainder
    #   r11 - totient_value

    # Push the stack
    SUB sp, sp, #36
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]
    STR r8, [sp, #20]
    STR r9, [sp, #24]
    STR r10, [sp, #28]
    STR r11, [sp, #32]

    MOV r4, r0 @ Move e into r4 (divisor)
    MOV r5, r1 @ Move totient value into r5 (remainder_base)
    MOV r11, r1 @ Store totient value in r11

    MOV r6, #0 @ Initialize old_inverse to 0
    MOV r7, #1 @ Initialize current_inverse to 1

    startCprivexpLoop:
        CMP r4, #0 
        BEQ endCprivexpLoop @ If divisor == 0, exit loop

        # quotient = remainder_base / divisor
        MOV r0, r5 @ r0 <- remainder_base
        MOV r1, r4 @ r1 <- divisor
        BL __aeabi_idiv @ r0 <- r5 / r4
        MOV r9, r0 @ r9 <- quotient

        # reaminder = remiander_base % divisor
        MOV r0, r5 @ r0 <- remainder_base
        MOV r1, r4 @ r1 <- divisor
        BL mod 
        MOV r10, r0 @ r10 <- remainder

        # temp_inverse = old_inverse - quotient * current_inverse
        MUL r8, r9, r7 @ r8 <- quotient * current_inverse
        SUB r8, r6, r8 @ r8 <- old_inverse - (quotient * current_inverse)

        # update inverses
        MOV r6, r7 @ old_inverse = current_inverse
        MOV r7, r8 @ current_inverse = temp_inverse

        # Update base and divisor
        MOV r5, r4 @ remainder_base = divisor
        MOV r4, r10 @ divisor  = remainder

        B startCprivexpLoop
    endCprivexpLoop:

    # if remainder_base != 1
    CMP r5, #1 
    BEQ checkOldInverse @ Modular inverse exists -> continue checks
    # then no modular inverse exists - return -1 to signal error
    MVN r0, #0
    B endCprivexp

    checkOldInverse:
        # if old_inverse < 0 (negative)
        CMP r6, #0
        BGE returnOld_inverse @ No changes necessary, return old_inverse as is
        # then fix the negative inverse
        ADD r0, r6, r11 @ r0 <- old_inverse + totient_value
        B endCprivexp @ retrun r0 (this is d)

    returnOld_inverse:
        MOV r0, r6 @ r0 <- old_inverse
        B endCprivexp @ retrun old_inverse (this is d)

    endCprivexp:
    # Pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    LDR r9, [sp, #24]
    LDR r10, [sp, #28]
    LDR r11, [sp, #32]
    ADD sp, sp, #36
    MOV pc, lr
# END cprivexp
