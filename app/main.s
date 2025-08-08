.text
.global main
main:
    SUB sp, sp, #4
    STR lr, [sp, #0]

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
    B endMain

    checkEncrypt:
    # If user selection == 1
    CMP r1, #1
    BNE checkDecrypt
    # Then encrypt message
    BL encrypt

    checkDecrypt:
    # If user selection == 2
    CMP r1, #2
    BNE endMain
    # Then decrypt message
    # MOV r0, #0
    MOV r0, #103
    MOV r1, #143
    BL testfunc

    endMain:
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    formatInt: .asciz "%d"
    promptMenu: .asciz "Please select an option by entering the corresponding number:\n\n0 - Generate Keys\n1 - Encrypt a message\n2 - Decrypt a message\n3 - Exit the program\n\nEnter your choice (0,1, 2, or 3): "
    inputSelection: .word -1 
    test: .asciz "This sucks"




