#
# Program Name: main.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/25/2025
# Purpose:
#   This is the main driver program to test the mod function defined in libMod.s.
#   It prompts the user to enter a dividend and a divisor, calls the mod function 
#   to compute the remainder, and prints the result to the console.
#
# Dependencies:
#   - Requires linking with libMod.s for the `mod` function.
#   - Uses C library functions: printf, scanf
#
# Inputs:
#   - User provides two integers via console input:
#     * Dividend (numerator)
#     * Divisor  (denominator)
#
# Outputs:
#   - Prints the result of dividend mod divisor to the console.
#
# Example Flow:
#   Enter dividend (x): -7
#   Enter divisor (y): 3
#   Result: 2
#
.global main
.text
main:
    @ Push the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    @ Prompt for dividend
    LDR r0, =prompt1
    BL printf

    LDR r0, =formatInt
    LDR r1, =dividend
    BL scanf

    @ Prompt for divisor
    LDR r0, =prompt2
    BL printf

    LDR r0, =formatInt
    LDR r1, =divisor
    BL scanf

    @ Load inputs into r0 and r1
    LDR r0, =dividend
    LDR r0, [r0]        @ r0 = dividend
    LDR r1, =divisor
    LDR r1, [r1]        @ r1 = divisor

    @ Call mod function
    BL mod              @ r0 = mod(r0, r1)

    @ Print result
    LDR r1, =resultMsg
    MOV r1, r0          @ move result into r1
    LDR r0, =resultMsg
    BL printf

    # Pop the stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    dividend: .word 0
    divisor:  .word 0
    prompt1:   .asciz "Enter dividend (x): "
    prompt2:   .asciz "Enter divisor (y): "
    formatInt: .asciz "%d"
    resultMsg: .asciz "Result: %d\n"
