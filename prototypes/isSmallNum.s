.global isSmallNum

.text

#
# Function name: isSmallNum.s
# Author: Portia Stevenson
# Date: 7/28/2025
# Purpose: Given an integer, this function determines whether the 
# the integer is as small number (less than 50), and returns a Boolean 
# value indicating accordingly: 
# 1 if the number is small, and 0 if the number is not small.  
# 
# Input: int (integer, r0)
# Output: r0 (Boolean, r0)
#
isSmallNum:
  # Program dictionary: 
  # r8 - input integer
  # r0 - function argument and result

  # Push the stack
  SUB sp, sp, #4     
  STR lr, [sp]    

  MOV r8, r0 		// input integer in r8

  # if r8 < 50, it is small 
  # else: it is not small
  CMP r8, #50
  BGE else_notSmall
    MOV r0, #1
    B endIf
    
  else_notSmall: 
    MOV r0, #0
    B endIf

  endIf:
    # Pop from the stack and return to the OS
    LDR lr, [sp]    	
    ADD sp, sp, #4   
    MOV pc, lr          	

.data

# End isSmallNum function

