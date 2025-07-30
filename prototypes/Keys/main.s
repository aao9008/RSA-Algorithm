#
# Program Name: main.s
# Author: Alfredo Ormeno Zuniga
# Date: 7/30/2025
# Purpose:
#   This file serves as the main driver for testing RSA key component generation
#   in ARM Assembly. It prompts the user to input a public exponent and a totient value,
#   calls the cprivexp function to compute the private exponent, and prints the result.
#
# Functions:
#   - main: Reads user input, calls cprivexp, and prints the output.
#
# Inputs:
#   - Public exponent `e` (entered by user via scanf)
#   - Totient value φ(n) (entered by user via scanf)
#
# Outputs:
#   - Prints the private key exponent `d`, or -1 if no modular inverse exists.
#
.text
.global main
main:
    # Push the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    @ Prompt: "Enter public exponent e: "
    LDR r0, =promptE
    BL printf

    @ Read integer into r4
    LDR r0, =formatInput
    LDR r1, =e
    BL scanf

    @ Prompt: "Enter totient value: "
    LDR r0, =promptTotient
    BL printf

    @ Read integer into r5
    LDR r0, =formatInput
    LDR r1, =totient
    BL scanf

    @ Load arguments into r0 and r1 for cprivexp
    LDR r0, =e
    LDR r0, [r0]            @ r0 = value of e
    LDR r1, =totient
    LDR r1, [r1]            @ r1 = value of totient_value
    BL cprivexp             @ r0 = private exponent (or -1)

    @ Print the result
    MOV r1, r0              @ move result into r1 for printf
    LDR r0, =formatOutput
    BL printf

    # Pop the stack 
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    promptE:         .asciz "Enter public exponent e: "
    promptTotient:   .asciz "Enter totient value: "
    formatInput:     .asciz "%d"
    formatOutput:    .asciz "Private key exponent d = %d\n"
    e:               .word 0
    totient:         .word 0
