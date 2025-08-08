# Program Name: encrypt.s
# Author: Kosuke Ito
# Purpose: Encryption function to encrypted.txt

.text
.global encryptMessage

.extern mod
.extern pow
.extern fopen
.extern fprintf
.extern fclose

# Function: encryptMessage
# Purpose: Encrypt a string and write to encrypted.txt

# Inputs:
# r0 - pointer to input string
# r1 - public key exponent (e)
# r2 - RSA modulus (n)
# Output:
# r0 - number of characters encrypted

encryptMessage:
	# Program Dictionary:
	# r4 - String pointer
	# r5 - exponent (e)
	# r6 - modulus (n)
	# r7 - file handle
	# r8 - character counter

	# Push
	SUB sp, sp, #24
	STR lr, [sp, #20]
	STR r4, [sp, #16]
	STR r5, [sp, #12]
	STR r6, [sp, #8]
	STR r7, [sp, #4]
	STR r8, [sp]

	# Copy into preserved registers
	MOV r4, r0	// input string poiter to r4
	MOV r5, r1	// exponent e to r5
	MOV r6, r2	// modulus n to r6

	# Open output file
	LDR r0, =outputFile
	LDR r1, =open
	BL fopen
	MOV r7, r0	// file pointer to r7

	MOV r8, #0	// set character count = 0
	MOV r1, r5	// e back into r1
	MOV r0, r4	// string back into r0

	encrypt_loop:
		LDRB r1, [r0]		// load ASCII
		ADD r0, r0, #1		// move pointer to next
		CMP r1, #0		// if end of string, exit
		BEQ encrypt_done

		SUB sp, sp, #4		// stack pointer down
		STR r0, [sp]		// store r0 at top

		# get m^e using pow function
		MOV r0, r1		// m into r0
		MOV r1, r5		// e into r1
		BL pow

		# get c = (m^e) mod n using mod function
		MOV r1, r6		// n into r1
		BL mod

		# Write
		SUB sp, sp, #4
		STR r0, [sp]
		MOV r2, r0		// encrypted to r2
		MOV r0, r7
		LDR r1, =printFormat
		BL fprintf
		ADD sp, sp, #4

		LDR r0, [sp]
		ADD sp, sp, #4
		ADD r8, r8, #1		// count += 1
		B encrypt_loop

	encrypt_done:
		# Close txt
		MOV r0, r7
		BL fclose

		MOV r0, r8	// r0 count

		# Pop
		LDR r8, [sp]
		LDR r7, [sp, #4]
		LDR r6, [sp, #8]
		LDR r5, [sp, #12]
		LDR r4, [sp, #16]
		LDR lr, [sp, #20]
		ADD sp, sp, #24
		MOV pc, lr

.data
	outputFile:	.asciz "encrypted.txt"
	open:	.asciz "w"
	printFormat:	.asciz "%d "
