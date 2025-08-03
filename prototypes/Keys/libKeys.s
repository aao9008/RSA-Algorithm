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
#   - cprivexp:      Computes the modular inverse of e mod totientValue to produce d.
#
# Inputs:
#   Vary by function — see individual function headers for specific usage.
#
# Outputs:
#   Vary by function — see individual function headers for specific usage.
#

# Function: cprivexp
# Purpose: Compute the private key exponent `d` such that (d * e) ≡ 1 mod totientValue,
#          using the Extended Euclidean Algorithm.
#
# Input:   r0 - public exponent (e)
#          r1 - totient value of n (totientValue = (p - 1)(q - 1))
#
# Output:  r0 - private exponent (d), such that (d * e) mod totientValue = 1
#          Returns -1 if no modular inverse exists (i.e., e and totientValue are not coprime)
#
# Pseudo Code:
#   int cprivexp(int e, int totientValue) {
#       remainder_base = totientValue
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
#           return -1   // e and totientValue not coprime
#
#       if (old_inverse < 0)
#           old_inverse = old_inverse + totientValue
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
    #   r11 - totientValue

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
        ADD r0, r6, r11 @ r0 <- old_inverse + totientValue
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

# Function: validateE
# Purpose: Validate a candidate public exponent `e` for RSA, ensuring that it:
#          - Is a positive integer
#          - Satisfies 1 < e < totientValue
#          - Is coprime to the totient using the GCD function
#
# Input:    r0 - candidate e value
#           r1 - totient value (Φ(n) = (p - 1)(q - 1))
#
# Output:  r0 - validated public exponent (e)
#
# Pseudocode:
#   int validateE(int e, int totientValue) {
#       isInRange = (e > 1) && (e < totientValue)
#       isCoprime = (gcd(e, totientValue) == 1)
#       return isInRange && isCoprime
#   }
#
.text
validateE:
    # Program Dictionary
    #   r4 - value e (candidate exponent)
    #   r5 - totientValue (Φ(n))
    #   r6 - condition flag for 1 < e
    #   r7 - reused for totient and gcd checks
    
    # Push the stack to preserve return address and callee-saved registers
    SUB sp, sp, #20
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]

    # Store passed arguments into preserved registers
    MOV r4, r0 @ r4 <- e
    MOV r5, r1 @ r5 <- totientValue

    # Check if e > 1
    MOV r6, #1 @ assume true
    CMP r4, #1 @ compare e with 1
    MOVLT r6, #0 @ if e <= 1, r2 = false

    # Check if e < totientValue
    MOV r7, #1 @ assume true
    CMP r4, r5 @ compare e with totient
    MOVGE r7, #0 @ if e >= totientValue, r3 = false

    # Combine range checks: 1 < e < totientValue
    AND r6, r6, r7 @ r2 = r2 && r3

    # Check if gcd(e, totientValue) == 1
    MOV r7, #1 @ assume true
    MOV r0, r4 @ r0 <- e
    MOV r1, r5 @ r1 <- totient
    BL gcd @ call gcd(e, totient)
    CMP r0, #1
    MOVNE r7, #0 @ if gcd != 1, r3 = false

    # Combine all checks: (1 < e < totientValue) && (gcd == 1)
    AND r0, r6, r7 @ final result in r0

    # Pop the stack and return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    ADD sp, sp, #20
    MOV pc, lr
# END validateE

# Function: cpubexp
# Purpose:
#   Finds the smallest valid public exponent `e` such that:
#     1 < e < totientValue
#     gcd(e, totientValue) == 1
#
# Input:
#   r0 - totient value (Φ(n))
#
# Output:
#   r0 - valid public exponent e (smallest possible satisfying conditions)
#
# Pseudocode:
#   int cpubexp(int totientValue) {
#       for (int e = 2; e < totientValue; e++) {
#           if (validateE(e, totientValue))
#               return e;
#       }
#       return -1; // Should never happen if totientValue > 2
#   }
#
.text
.global  cpubexp
cpubexp:
    # Program Dictionary
    #   r0 - input/output register
    #        On entry: totient value (Φ(n))
    #        On exit:  valid public exponent e, or -1 if none found
    #
    #   r1 - used as argument to validateE (totient value, copied from r5)
    #
    #   r4 - candidate public exponent `e` (starting at 2, incremented each loop)
    #
    #   r5 - stored totient value (Φ(n)), copied from r0 for repeated use
    #

    # Push the stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    MOV r4, #2 @ Initilaize e (r4 <- 2)
    MOV r5, r0 @ r5 <- totientValue

    startCpubexpLoop:
        CMP r4, r5
        BGE endCpubexpLoop @ if e >= totientValue, exit loop

        # Validate E
        MOV r0, r4 @ r0 <- e
        MOV r1, r5 @ r1 <- totientValue
        BL validateE @ r0 <- isValid (boolean)

        CMP r0, #1
        BNE cpubexpNext @ if isValid == false, move to next iteration
        MOV r0, r4
        B endCpubexp
        
        cpubexpNext:
        ADD r4, r4, #1 @ e++
        B startCpubexpLoop
    endCpubexpLoop:

    MVN r0, #0 @ no valid e found, return -1

    endCpubexp:
    # Pop the stack 
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
# END cpubexp



    

