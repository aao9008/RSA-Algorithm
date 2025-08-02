.global isPositive

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
# Input: int (integer, r0)
# Output: isPos (Boolean, r0)
#
isPositive:
  # Program dictionary:
  # r8 - input integer
  # r0 - function argument and result

  # Push the stack
  SUB sp, sp, #4     
  STR lr, [sp]    

  MOV r8, r0 		// input integer in r8

  # if r8 > 0, it is positive
  # else: it is not positive
  CMP r8, #0
  BLE else_notPos
    MOV r0, #1
    B endIf_isPositive
    
  else_notPos: 
    MOV r0, #0

  endIf_isPositive:
    # Pop from the stack and return to the OS
    LDR lr, [sp]    	
    ADD sp, sp, #4   
    MOV pc, lr          	

.data

# End isPositive function

