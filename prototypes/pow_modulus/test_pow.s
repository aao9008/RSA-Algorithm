.text
.global main
.extern printf
.extern scanf
.extern pow

main:
	# Push
	SUB sp, sp, #16
	STR lr, [sp, #12]
	STR r4, [sp, #8]
	STR r5, [sp, #4]

	# Read in base to r4
	LDR r0, =prompt_base
	BL printf
	LDR r0, =format_in
	ADD r1, sp, #0
	BL scanf
	LDR r4, [sp]

	# Read in exponent to r5
	LDR r0, =prompt_exponent
	BL printf
	LDR r0, =format_in
	ADD r1, sp, #4
	BL scanf
	LDR r5, [sp, #4]

	# Call pow function
	MOV r0, r4
	MOV r1, r5
	BL pow
	MOV r6, r0	// temporarily move result to r6

	# Print
	MOV r1, r4	// base
	MOV r2, r5	// exponent
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
	prompt_base:	.asciz "Enter base number: "
	prompt_exponent:	.asciz "Enter exponent: "
	format_in:	.asciz "%d"
	format_out:	.asciz "%d^%d = %d\n"
