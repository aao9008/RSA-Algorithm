# Program name: main.s
# Author: Team 3
# Date: 8/8/25
# Purpose: 
#   This program provides a menu-driven interface that allows the user to:
#   1. Generate RSA keys (public and private)
#   2. Encrypt a message using the generated public key
#   3. Decrypt a message using the generated private key
#   4. Exit the program
#
# Inputs:
#   - User input for RSA key generation parameters (p, q, e, n, d)
#   - Message for encryption
#
# Outputs:
#   - Public and private keys (e, n, d)
#   - Encrypted message
#   - Decrypted message
#
# Algorithm:
#   - Menu-based user interface offering 4 options
#   - Key generation based on user-provided prime numbers p and q
#   - Message encryption using the public key
#   - Message decryption using the private key
#   - Option to exit the program

.text
.global main
main:
    SUB sp, sp, #4
    STR lr, [sp, #0]

    startSelectionLoop:
        # Prompt user with selection menu
        LDR r0, =promptMenu
        BL printf

        # Scan for user input (integer)
        LDR r0, =formatInt
        LDR r1, =inputSelection
        BL scanf

        # Load user input selection
        LDR r1, =inputSelection
        LDR r1, [r1, #0]
        
        # If user selection == 0
        CMP r1, #0
        BNE checkEncrypt
        # Then Generate and display keys
        BL generateAndDisplayKeys
        B endSelectionLoop

        checkEncrypt:
        # If user selection == 1
        CMP r1, #1
        BNE checkDecrypt
        # Then encrypt message
        BL encrypt
        B endSelectionLoop

        checkDecrypt:
        # If user selection == 2
        CMP r1, #2
        BNE checkExit
        # Then decrypt message
        BL decrypt
        B endSelectionLoop

        checkExit:
        # If user selection == 3
        CMP r1, #3
        BNE startSelectionLoop
    endSelectionLoop:
    
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
# END main

.data
    formatInt: .asciz "%d"
    promptMenu: .asciz "\nPlease select an option by entering the corresponding number:\n\n0 - Generate Keys\n1 - Encrypt a message\n2 - Decrypt a message\n3 - Exit the program\n\nEnter your choice (0,1, 2, or 3): "
    inputSelection: .word -1 




