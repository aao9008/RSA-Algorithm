# Program Name:	pow_modulus.s
# Author:	Kosuke Ito
# Purpose: 	pow & modulus functions

.text
.global pow
.global modulus

# BEGIN POW

# Input: r0 base, r1 exponent
# Output: r0 = base^exponent

# register use inside pow:
	# r0 = base
	# r1 = exponent
	# r2 = current product (updated after each multiplication)
	# r3 = counter for multiplication times

pow:
	SUB sp, sp, #8
	STR lr, [sp, #4]
	STR r4, [sp]

	MOV r2, r0	// initialize r2 as base
	MOV r3, #1	// exponent counter = 1 when r2 = base

	# return 1 when exponent = 0
	CMP r1, #0
	MOVEQ r0, #1
	BEQ pow_done

	# return r0 itself when exponent = 1
	CMP r1, #1
	BEQ pow_done

pow_loop:
	CMP r3, r1	// r3 counter >= r1 exponent means no more multiplication
	BGE pow_done

	MOV r4, r2	// r2 current result goes to r4 temporarily
	MUL r2, r4, r0	// r2 = base * current r4
	ADD r3, r3, #1	// counter += 1
	B pow_loop	// loop again

    
pow_done:
	MOV r0, r2	// move r2 current to r0 for output

	LDR r4, [sp]
	LDR lr, [sp, #4]
	ADD sp, sp, #8
	MOV pc, lr

# END POW

# BEGIN MODULUS

# Input: r0, r1
# Output: r0 = n = p * q

# Register use inside modulus:
	# r0 = p
	# r1 = q

modulus:

	SUB sp, sp, #4
	STR lr, [sp]

	MOV r2, r0	// copy p to r2; r0 for output
	MUL r0, r2, r1	// r0 = p*q = r2*r1
    
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

# END MODULUS
