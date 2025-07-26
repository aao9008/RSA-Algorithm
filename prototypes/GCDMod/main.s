#
# Program Name: main.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/25/2025
# Purpose:
#   This is the main driver program used to test the utility functions defined in libMod.s.
#   It prompts the user for two integers (a dividend and a divisor), calls the `mod` function
#   to compute the mathematical remainder, and the `gcd` function to compute the greatest
#   common divisor. It then prints both results to the console.
#
# Dependencies:
#   - Requires linking with libMod.s for access to:
#       * mod: Computes the remainder (a mod b)
#       * gcd: Computes the greatest common divisor
#
# Inputs:
#   - User-provided console input (integers)
#
# Outputs:
#   - Console output showing:
#       * The result of the modulus operation (dividend mod divisor)
#       * The result of the GCD operation (gcd of the two inputs)
#

.global main
.text
main:
    @ Push the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    #-----------------Mod Function Test---------------------
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

    #---------------GCD Function Test----------------
    # Prompt user for input
    LDR r0, =prompt3
    BL printf

    # Scan user input 
    LDR r0, =format2Int
    LDR r1, =num1
    LDR r2, =num2
    BL scanf

    # Calcualte the GCD
    LDR r0, =num1
    LDR r0, [r0, #0]
    LDR r1, =num2
    LDR r1, [r1, #0]
    BL gcd

    # Print the gcd
    MOV r1, r0
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
    prompt3: .asciz "Enter two numbers please. We will find the gcd for these numbers: "
    formatInt: .asciz "%d"
    format2Int: .asciz "%d%d"
    num1: .word 0
    num2: .word 0
    resultMsg: .asciz "Result: %d\n\n"
