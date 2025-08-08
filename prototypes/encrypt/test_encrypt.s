// Program Name: test_encrypt.s

.text
.global main

.extern encryptMessage
.extern printf
.extern scanf
.extern getchar

main:
	SUB sp, sp, #4
	STR lr, [sp, #0]

	LDR r0, =prompt_e
	BL printf
	LDR r0, =input_format
	LDR r1, =e_num
	BL scanf

	LDR r0, =prompt_n
	BL printf
	LDR r0, =input_format
	LDR r1, =n_num
	BL scanf

	LDR r0, =prompt_string
	BL printf

	BL getchar

	LDR r0, =line_format
 	LDR r1, =buffer
	BL scanf

	LDR r0, =buffer
	LDR r1, =e_num
	LDR r1, [r1]
	LDR r2, =n_num
	LDR r2, [r2]
	LDR r3, =word_array
	BL encryptMessage

	MOV r1, r0
	LDR r0, =result_msg
	BL printf

	MOV r0, #0
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	prompt_e:	.asciz "Enter exponent (e): "
	prompt_n:	.asciz "Enter modulus (n): "
	prompt_string:	.asciz "Enter string to encrypt: "
	result_msg:	.asciz "Encrypted %d characters\n"
	input_format:	.asciz "%d"
	string_format:	.asciz "%s"
	line_format:	.asciz "%[^\n]"
	e_num:		.word 0
	n_num:		.word 0
	buffer:		.space 256
	word_array:	.space 80
