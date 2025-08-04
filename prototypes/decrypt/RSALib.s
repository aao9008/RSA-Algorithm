#
# Library name: RSALib.s
# Author: Portia Stevenson
# Date: 8/3/2025
# Purpose: This library contains multiple functions required for 
# an RSA Algorithm designed by 605.204 SU25 Team 3 for national 
# security and defense personnel assigned to deployed forward 
# operating bases. 
# 


.global isSmallNum
.global totient
.global isPositive
.global decrypt


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

