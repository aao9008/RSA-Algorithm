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
.global isPositive
.global totient


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


