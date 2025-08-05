#
# Library name: RSALib.s
# Author: Team 3
# Date: 8/3/2025
# Purpose: This library contains multiple functions required for 
# an RSA Algorithm designed by 605.204 SU25 Team 3 for national 
# security and defense personnel assigned to deployed forward 
# operating bases. 
# 


.global pow
.global modulus
.global totient
.global mod
.global gcd
.global isSmallNum
.global isPositive
.global isPrime
.global cprivexp
.global validateE
.global cpubexp
.global decrypt
# .global encrypt




.text

# Function: pow
# Author:  Kosuke Ito
# Purpose: Computes the result of applying an exponent to a base number
#
# Inputs:
# 	r0 - base
# 	r1 - exponent
# Output:
# 	r0 - base^exponent
#
# Pseudo Code:
#	if exponent == 0:
#		return 1
#	if exponent == 1:
#		return base
#	result = base
#	counter = 1
#	while counter < exponent:
#		result = result * base
#		counter += 1
#	return result

pow:
	SUB sp, sp, #8
	STR lr, [sp, #4]
	STR r4, [sp]

	MOV r2, r0	// initialize r2 (current calculated product) as base
	MOV r3, #1	// exponent counter at r3 = 1 when r2 = base

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

# END pow



.text

# Function: modulus
# Author:  Kosuke Ito
# Purpose: Compute n = p * q
#
# Inputs:
#	r0 - prime positive integer p
#	r1 - prime positive integer q
# Output:
#	r0 - n = p * q
#
# Pseudo Code:
#	n = p * q
#	return n

modulus:

	SUB sp, sp, #4
	STR lr, [sp]

	MOV r2, r0	// copy p to r2; r0 for output
	MUL r0, r2, r1	// r0 = p*q = r2*r1
    
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

# END modulus



.text

#
# Function name: totient.s
# Author: Portia Stevenson
# Date: 7/8/2025
# Purpose: Given input integers p and q, this function calculates 
# and returns the totient. 
# The formula used to calculate the totient is:  Φ(n) = (p - 1)(q - 1)
# 
# Inputs: 
#    - p: integer, stored in r0 
#    - q: integer, stored in r1
# Output: 
#    - totient: integer, stored in r0

totient:
  # Program dictionary:
  # r0 - input integer p (function argument); subsequently p-1; subsequently totient
  # r1 - input integer q (function argument); subsequently q-1   

  # Push the stack
  SUB sp, sp, #4     
  STR lr, [sp]    

  SUB r0, r0, #1      // p-1 in r0
  SUB r1, r1, #1      // q-1 in r1
  MUL r0, r0, r1      // totient in r0
  
  # Pop from the stack and return to the OS
  LDR lr, [sp]    	
  ADD sp, sp, #4   
  MOV pc, lr          	

.data

# END OF totient



# Function: mod
# Author: Alfredo Ormeno Zuniga
# Date: 7/25/2025
# Purpose: To compute the non-negative remainder of two signed integers.
#
# Input:
#   r0 - Dividend (numerator)
#   r1 - Divisor  (denominator)
#
# Output:
#   r0 - The non-negative remainder (r0 mod r1)
#
# Pseudo Code:
#   int mod(int x, int y) {
#       int quotient = x / y;
#       int product = quotient * y;
#       int remainder = x - product;
#       if (remainder < 0) {
#           remainder = remainder + y;
#       }
#       return remainder;
#   }
.text
mod:
    # Program Dictionary 
    #   r4 - dividend
    #   r5 - divisor 
    #   r6 - quotient
    #   r7 - product of quotient and divisor 

    # Push the stack
    SUB sp, sp, #20
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]

    # Copy passed arguments into r4 and r5
    MOV r4, r0 @ r4 <- dividend
    MOV r5, r1 @ r5 <- divisor

    # Perform division (r0 - dividend, r1 - divisor)
    BL __aeabi_idiv @ r0 <- r0 / r1

    # Store result of divsion function
    MOV r6, r0 @ r6 <- r0 (result)

    # Get the product of the quotient and divisor
    MUL r7, r6, r5

    # Subtract the product from the dividend to get the remainder
    SUB r0, r4, r7

    # Fix for negative remainder
    CMP r0, #0 @ if remainder < 0
    ADDLT r0, r0, r5 @ then add divisor

    # Pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    ADD sp, sp, #20
    MOV pc, lr
# END mod



# Function: GCD
# Author: Alfredo Ormeno Zuniga
# Date: 7/25/2025
# Purpose: Computes the greatest common divisor of two integers using the Euclidean Algorithm.
#
# Input:  r0 - first integer (a)
#         r1 - second integer (b)
# Output: r0 - the greatest common divisor of a and b
#
# Pseudo Code:
#   int GCD(int a, int b) {
#       while (b != 0) {
#           int temp = b;
#           b = a % b;
#           a = temp;
#       }
#       return a;
#   }
.text
gcd:
    # Program Dictionary
    #   r4 - absolute value of first integer (a)
    #   r5 - absolute value of second integer (b)
    #   r6 - temporary value (temp)

    # Push the stack
    SUB sp, sp, #16
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    @ Ensure r0 is non-negative
    CMP r0, #0
    BGE skip_abs0
    RSBS r0, r0, #0 @ r0 = -r0
    skip_abs0:

    @ Ensure r1 is non-negative
    CMP r1, #0
    BGE skip_abs1
    RSBS r1, r1, #0 @ r1 = -r1
    skip_abs1:

    # Copy input arguments into preserved registers
    MOV r4, r0
    MOV r5, r1

    startGCDLoop:
        CMP r5, #0
        BEQ endGCDLoop @ if b == 0, exit loop

        MOV r6, r5 @ temp = b

        # Calculate a mod b (mod will use r0, r1 and return result in r0)
        MOV r0, r4
        MOV r1, r5
        BL mod

        MOV r4, r6 @ a = temp
        MOV r5, r0 @ b = a % b
        
        B startGCDLoop
    endGCDLoop:

    # Return the value of a (GCD)
    MOV r0, r4

    # Pop the stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr
# END gcd



.text

#
# Function Name: isSmallNum.s
# Author: Portia Stevenson
# Date: 7/28/2025
# Purpose: Given an integer, this function determines whether the 
# the integer is as small number (less than 50), and returns a Boolean 
# value indicating accordingly: 
# 1 if the number is small, and 0 if the number is not small.  
# 
# Input: 
#   - int: integer, stored in r0
# Output: 
#   - smallNum: Boolean, stored in r0
#
isSmallNum:
  # Program dictionary: 
  # r4 - input integer for safekeeping
  # r0 - function argument and result

  # Push the stack
  SUB sp, sp, #8     
  STR lr, [sp, #0]
  STR r4, [sp, #4]    

  MOV r4, r0 		// input integer in r4

  # if r4 < 50, it is small 
  # else: it is not small
  CMP r4, #50
  BGE else_notSmall
    MOV r0, #1
    B endIf
    
  else_notSmall: 
    MOV r0, #0
    B endIf

  endIf:
    # Pop from the stack and return to the OS
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]    	
    ADD sp, sp, #8   
    MOV pc, lr          	

.data

# END OF isSmallNum



.text

#
# Function name: isPositive.s
# Author: Portia Stevenson
# Date: 7/28/2025
# Purpose: Given an integer, this function determines whether the 
# the integer is positive, and returns a Boolean value indicating 
# accordingly: 1 if the number is positive, and 0 if the number is 
# not positive.  
# 
# Input: 
#   - int: integer, stored in r0
# Output: 
#   - isPos: Boolean, stored in r0
#

isPositive:
  # Program dictionary:
  # r4 - input integer
  # r0 - function argument and result

  # Push the stack
  SUB sp, sp, #8     
  STR lr, [sp, #0]
  STR r4, [sp, #4]    

  MOV r4, r0 		// input integer in r4

  # if r4 > 0, it is positive
  # else: it is not positive
  CMP r4, #0
  BLE else_notPos
    MOV r0, #1
    B endIf_isPositive
    
  else_notPos: 
    MOV r0, #0

  endIf_isPositive:
    # Pop from the stack and return to the OS
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]    	
    ADD sp, sp, #8  
    MOV pc, lr          	

.data

# END OF isPositive



# Function Name: isPrime
# Author:	Brian Astrove
# Date:		July 29, 2025
# Purpose:	A utility function to determine if integer is prime
# External dependencies: __aeabi_idiv
# 
# Inputs: 
#  r0 - the number to evaluate if its prime
#  
# Outputs:
#  r0 - a boolean result: 0 = not prime, 1 = prime
#  
# Pseudo code: 
#  if int n <= 1: return False
#  for i in range(2, sqrt(n) +1):
#    if n % i == 0
#      Return False
#  Return True
# 
#  Why this works:
#    2 is the first real prime number
#    suppose n = a x b. If both a and b are greater than sqrt(n), then a x b > n, which is not a valid case.
#    so if n has any divisors, at lease of of them must be less or equal to sqrt(n)
# 
.text
.extern __aeabi_idiv
 
isPrime:
    # push the stack
    SUB sp, sp, #16
    STR lr, [sp]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    # number expected in r0, store in r6
    MOV r6, r0

    # check if n < 2, and thus not prime
    CMP r6, #2
    BLT NotPrime

    MOV r4, #2

loop:
    # checks if loop has reached i^2 which determines the number is prime
    MUL r3, r4, r4
    CMP r3, r6
    BGT Prime 

    # divides the input by current loop index
    # if no remainder, the number is evenly divisible and the input is determined not prime
    MOV r0, r6
    MOV r1, r4
    BL __aeabi_idiv
    MOV r5, r0
    MUL r3, r5, r4
    CMP r3, r6
    BEQ NotPrime

    # add 1 to the index and run the loop again
    ADD r4, r4,#1
    B loop

Prime:
    # if prime, set r0 to 1
    MOV r0, #1
    B Done

NotPrime:
    # if not prime, set r0 to 0
    MOV r0, #0
    B Done

Done:
    #pop the stack
    LDR lr, [sp]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]   
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr

#END isPrime



# Function: cprivexp
# Author: Alfredo Ormeno Zuniga
# Date: 7/30/2025
# Purpose: Compute the private key exponent `d` such that (d * e) must equal 1 mod totientValue,
#          using the Extended Euclidean Algorithm.
#
# Input:   r0 - public exponent (e)
#          r1 - totient value of n (totientValue = (p - 1)(q - 1))
#
# Output:  r0 - private exponent (d), such that (d * e) mod totientValue = 1
#          Returns -1 if no modular inverse exists (i.e., e and totientValue are not coprime)
#
# Pseudo Code:
#   int cprivexp(int e, int totientValue) {
#       remainder_base = totientValue
#       divisor = e
#       old_inverse = 0
#       current_inverse = 1
#
#       while (divisor !=  0) {
#           quotient = remainder_base / divisor
#           remainder = remainder_base % divisor
#
#           temp_inverse = old_inverse - quotient * current_inverse
#           old_inverse = current_inverse
#           current_inverse = temp_inverse
#
#           remainder_base = divisor
#           divisor = remainder
#       }
#
#       if (remainder_base != 1)
#           return -1   // e and totientValue not coprime
#
#       if (old_inverse < 0)
#           old_inverse = old_inverse + totientValue
#
#       return old_inverse  // this is d
#   }

.text
cprivexp:
    # Program Dictionary
    #   r4 - divisor (starts as public exponenet e)
    #   r5 - remainder_base (starts as totient value)
    #   r6 - old_inverse
    #   r7 - current_inverse
    #   r8 - temp_inverse
    #   r9 - quotient
    #   r10 - remainder
    #   r11 - totientValue

    # Push the stack
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

    MOV r4, r0 @ Move e into r4 (divisor)
    MOV r5, r1 @ Move totient value into r5 (remainder_base)
    MOV r11, r1 @ Store totient value in r11

    MOV r6, #0 @ Initialize old_inverse to 0
    MOV r7, #1 @ Initialize current_inverse to 1

    startCprivexpLoop:
        CMP r4, #0 
        BEQ endCprivexpLoop @ If divisor == 0, exit loop

        # quotient = remainder_base / divisor
        MOV r0, r5 @ r0 <- remainder_base
        MOV r1, r4 @ r1 <- divisor
        BL __aeabi_idiv @ r0 <- r5 / r4
        MOV r9, r0 @ r9 <- quotient

        # reaminder = remiander_base % divisor
        MOV r0, r5 @ r0 <- remainder_base
        MOV r1, r4 @ r1 <- divisor
        BL mod 
        MOV r10, r0 @ r10 <- remainder

        # temp_inverse = old_inverse - quotient * current_inverse
        MUL r8, r9, r7 @ r8 <- quotient * current_inverse
        SUB r8, r6, r8 @ r8 <- old_inverse - (quotient * current_inverse)

        # update inverses
        MOV r6, r7 @ old_inverse = current_inverse
        MOV r7, r8 @ current_inverse = temp_inverse

        # Update base and divisor
        MOV r5, r4 @ remainder_base = divisor
        MOV r4, r10 @ divisor  = remainder

        B startCprivexpLoop
    endCprivexpLoop:

    # if remainder_base != 1
    CMP r5, #1 
    BEQ checkOldInverse @ Modular inverse exists -> continue checks
    # then no modular inverse exists - return -1 to signal error
    MVN r0, #0
    B endCprivexp

    checkOldInverse:
        # if old_inverse < 0 (negative)
        CMP r6, #0
        BGE returnOld_inverse @ No changes necessary, return old_inverse as is
        # then fix the negative inverse
        ADD r0, r6, r11 @ r0 <- old_inverse + totientValue
        B endCprivexp @ retrun r0 (this is d)

    returnOld_inverse:
        MOV r0, r6 @ r0 <- old_inverse
        B endCprivexp @ retrun old_inverse (this is d)

    endCprivexp:
    # Pop the stack
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
# END cprivexp


# Function: validateE
# Author: Alfredo Ormeno Zuniga
# Date: 7/30/2025
# Purpose: Validate a candidate public exponent `e` for RSA, ensuring that it:
#          - Is a positive integer
#          - Satisfies 1 < e < totientValue
#          - Is coprime to the totient using the GCD function
#
# Input:    r0 - candidate e value
#           r1 - totient value (Φ(n) = (p - 1)(q - 1))
#
# Output:  r0 - validated public exponent (e)
#
# Pseudocode:
#   int validateE(int e, int totientValue) {
#       isInRange = (e > 1) && (e < totientValue)
#       isCoprime = (gcd(e, totientValue) == 1)
#       return isInRange && isCoprime
#   }
#
.text
validateE:
    # Program Dictionary
    #   r4 - value e (candidate exponent)
    #   r5 - totientValue (Φ(n))
    #   r6 - condition flag for 1 < e
    #   r7 - reused for totient and gcd checks
    
    # Push the stack to preserve return address and callee-saved registers
    SUB sp, sp, #20
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]

    # Store passed arguments into preserved registers
    MOV r4, r0 @ r4 <- e
    MOV r5, r1 @ r5 <- totientValue

    # Check if e > 1
    MOV r6, #1 @ assume true
    CMP r4, #1 @ compare e with 1
    MOVLT r6, #0 @ if e <= 1, r2 = false

    # Check if e < totientValue
    MOV r7, #1 @ assume true
    CMP r4, r5 @ compare e with totient
    MOVGE r7, #0 @ if e >= totientValue, r3 = false

    # Combine range checks: 1 < e < totientValue
    AND r6, r6, r7 @ r2 = r2 && r3

    # Check if gcd(e, totientValue) == 1
    MOV r7, #1 @ assume true
    MOV r0, r4 @ r0 <- e
    MOV r1, r5 @ r1 <- totient
    BL gcd @ call gcd(e, totient)
    CMP r0, #1
    MOVNE r7, #0 @ if gcd != 1, r3 = false

    # Combine all checks: (1 < e < totientValue) && (gcd == 1)
    AND r0, r6, r7 @ final result in r0

    # Pop the stack and return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    ADD sp, sp, #20
    MOV pc, lr
# END validateE



# Function: cpubexp
# Author: Alfredo Ormeno Zuniga
# Date: 7/30/2025
# Purpose:
#   Finds the smallest valid public exponent `e` such that:
#     1 < e < totientValue
#     gcd(e, totientValue) == 1
#
# Input:
#   r0 - totient value (Φ(n))
#
# Output:
#   r0 - valid public exponent e (smallest possible satisfying conditions)
#
# Pseudocode:
#   int cpubexp(int totientValue) {
#       for (int e = 2; e < totientValue; e++) {
#           if (validateE(e, totientValue))
#               return e;
#       }
#       return -1; // Should never happen if totientValue > 2
#   }
#
.text

cpubexp:
    # Program Dictionary
    #   r0 - input/output register
    #        On entry: totient value (Φ(n))
    #        On exit:  valid public exponent e, or -1 if none found
    #
    #   r1 - used as argument to validateE (totient value, copied from r5)
    #
    #   r4 - candidate public exponent `e` (starting at 2, incremented each loop)
    #
    #   r5 - stored totient value (Φ(n)), copied from r0 for repeated use
    #

    # Push the stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    MOV r4, #2 @ Initilaize e (r4 <- 2)
    MOV r5, r0 @ r5 <- totientValue

    startCpubexpLoop:
        CMP r4, r5
        BGE endCpubexpLoop @ if e >= totientValue, exit loop

        # Validate E
        MOV r0, r4 @ r0 <- e
        MOV r1, r5 @ r1 <- totientValue
        BL validateE @ r0 <- isValid (boolean)

        CMP r0, #1
        BNE cpubexpNext @ if isValid == false, move to next iteration
        MOV r0, r4
        B endCpubexp
        
        cpubexpNext:
        ADD r4, r4, #1 @ e++
        B startCpubexpLoop
    endCpubexpLoop:

    MVN r0, #0 @ no valid e found, return -1

    endCpubexp:
    # Pop the stack 
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
# END cpubexp



#
# Function name: decrypt
# Author: Portia Stevenson
# Date: 8/4/2025
# Purpose: Reads encrypted ciphertext values from encrypted.txt, decrypts 
# each value using the RSA decryption formula m = c^d mod n, and writes 
# the decrypted characters to plaintext.txt file. Uses pow and modulo 
# functions for calculating m, which represents each decrypted character.
#
# Inputs:
#    - c: ciphertext value, integer, stored in r0
#    - d: private key exponent, integer, stored in r1
#    - n: modulus, integer, stored in r2
# Output:
#    - None: decrypted characters are written to plaintext.txt
#
# Algorithm:
#   Open encrypted.txt for reading
#   Open plaintext.txt for writing
#   While not end of file:
#     Read ciphertext value c from encrypted.txt
#     Compute c^d using pow function
#     Compute (c^d) mod n using modulo function to get plaintext character m
#     Write m to plaintext.txt
#   Close both files and return
#   

.text

decrypt:
  # Program dictionary:
  # r0 - ciphertext value c (input parameter)
  # r1 - private key exponent d (input parameter); subsequently 
  #      for temp storage and calculations
  # r2 - modulo n (input parameter); subsequently for temp 
  #      storage and calculations
  # r4 - ciphertext value c for safekeeping
  # r5 - private key exponent d for safekeeping
  # r6 - modulus n for safekeeping
  # r7 - reading file pointer for encrypted.txt
  # r8 - writing file pointer for plaintext.txt
  # r9 - decrypted character m

  # Push the stack
  SUB sp, sp, #28
  STR lr, [sp, #0]
  STR r4, [sp, #4]
  STR r5, [sp, #8]
  STR r6, [sp, #12]
  STR r7, [sp, #16]
  STR r8, [sp, #20]
  STR r9, [sp, #24]

  # Save input arguments for safekeeping
  MOV r4, r0 		// c in r4
  MOV r5, r1  		// d in r5
  MOV r6, r2 		// n in r6

  # Open encrypted.txt for reading
  LDR r0, =encryptedFile
  LDR r1, =read 	// reading mode for file
  BL fopen
  MOV r7, r0  		// reading file pointer in r7

  # Open plaintext.txt for writing
  LDR r0, =plaintextFile
  LDR r1, =write 	// writing mode for file
  BL fopen
  MOV r8, r0 		// writing file pointer in r8

  readLoop:
    # Read ciphertext value from encrypted.txt
    LDR r0, =formatString
    LDR r1, =ciphertext
    MOV r2, r7 		// reading file pointer
    BL fscanf
    
    # Check for end of file (EOF). 
    #   If file end (i.e. -1 in C), exit readLoop and end 
    #   reading of file
    #   Otherwise, read the cipher text value, calculate m, 
    #   and write the decrypted character to output file
    CMP r0, #-1
    BEQ endIf_ReadFile
      # Load ciphertext value
      LDR r1, =ciphertext
      LDR r1, [r1]        

      # Calculate c^d using pow function
      MOV r0, r1 	// c in r0
      MOV r1, r5   	// d in r1
      BL pow  		// c^d in r0

      # Calculate (c^d) mod n using modulo function
      MOV r1, r6 	// n in r1
      BL modulo 	// (c^d) mod n in r0
      MOV r9, r0 	// m (decrypted char) in r9
  
      # Write decrypted character to plaintext.txt
      MOV r0, r8 	// writing file pointer
      MOV r1, r9
      BL fputc

      # Read next character in the encrypted.txt file
      B readLoop

    endIf_ReadFile:
      # Close files
      MOV r0, r7
      BL fclose
      MOV r0, r8
      BL fclose

      # Pop the stack and return
      LDR lr, [sp, #0]
      LDR r4, [sp, #4]
      LDR r5, [sp, #8]
      LDR r6, [sp, #12]
      LDR r7, [sp, #16]
      LDR r8, [sp, #20]
      LDR r9, [sp, #24]
      ADD sp, sp, #28
      MOV pc, lr

.data
  formatStringFile:  .asciz "%d"
  ciphertext:  .word 0
  encryptedFile:  .asciz "encrypted.txt"
  plaintextFile:  .asciz "plaintext.txt"
  read:  .asciz "r"
  write:  .asciz "w"

# END OF decrypt



