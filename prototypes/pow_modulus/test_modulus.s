.text
.global main
.extern printf
.extern scanf
.extern modulus

main:
	# Push
	SUB sp, sp, #16
	STR lr, [sp, #12]
	STR r4, [sp, #8]
	STR r5, [sp, #4]

	LDR r0, =prompt_p
	BL printf

	# Read p to r4
	LDR r0, =format_in
	ADD r1, sp, #0
	BL scanf
	LDR r4, [sp]

	# Read q to r5
	LDR r0, =prompt_q
	BL printf
	LDR r0, =format_in
	ADD r1, sp, #4
	BL scanf
	LDR r5, [sp, #4]

	# Call modulus function
	MOV r0, r4
	MOV r1, r5
	BL modulus
	MOV r6, r0

	# Print
	MOV r1, r4	// p
	MOV r2, r5	// q
	MOV r3, r0	// result
	LDR r0, =format_out
	BL printf

	# Pop
	LDR r5, [sp, #4]
	LDR r4, [sp, #8]
	LDR lr, [sp, #12]
	ADD sp, sp, #16
	MOV pc, lr

.data
	prompt_p:	.asciz "Enter first number (p): "
	prompt_q:	.asciz "Enter second number (q): "
	format_in:	.asciz "%d"
	format_out:	.asciz "%d * %d = %d\n"
