# Program Name: encrypt.s
# Author: Kosuke Ito
# Purpose: RSA encryption function

.text
.global encryptMessage

# Functions from other files
.extern mod
.extern pow

# Function: encryptMessage
# Purpose: Encrypt a string using RSA
#
# Inputs:
# r0 - pointer to input string
# r1 - public key exponent (e)
# r2 - RSA modulus (n)
# r3 - pointer to output array of encrypted values
# Output:
# r0 - number of characters encrypted
#
# Note: r3 holds the pointer to the array of encrypted values.

encryptMessage:
	# Program Dictionary
	# r4 - points to current character in string
	# r5 - exponent (e)
	# r6 - modulus (n)
	# r7 - pointer to output array base
	# r8 - character count
	# r9 - current character ASCII
	# r10 - pow result
	# r11 - encrypted value

	# Push
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

	# Copy over into preserved  registers
	MOV r4, r0	// input string pointer to r4
	MOV r5, r1	// exponent e to r5
	MOV r6, r2	// modulus n to r6
	MOV r7, r3	// output array pointer to r7
	MOV r8, #0	// Set character count = 0

	encrypt_loop:
		# Load ASCII byte value into r9
		LDRB r9, [r4]

		# if NULL, end loop
		CMP r9, #0
		BEQ encrypt_done


		# get m^e using pow function
		MOV r0, r9	// m into r0
		MOV r1, r5	// e into r1
		BL pow
		MOV r10, r0	// result to r10

		# get c = (m^e) mod n using mod function
		MOV r0, r10	// m^e into r0
		MOV r1, r6	// n into r1
		BL mod
		MOV r11, r0	// c into r11

		# Store c into array location output[count]
		STR r11, [r7, r8, LSL #2]	// location is r7 array base address + r8*4

		# Move to next character
		ADD r4, r4, #1	// move string pointer to next character
		ADD r8, r8, #1	// count += 1

		B encrypt_loop

	encrypt_done:
		MOV r0, r8	// r0 count
		# Pop
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
# END encryptMessage
