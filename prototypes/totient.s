.global totient

.text

#
# Function name: totient.s
# Author: Portia Stevenson
# Date: 7/8/2025
# Purpose: Given input integers p and q, this function calculates 
# and returns the totient. 
# The formula used to calculate the totient is:  Φ(n) = (p - 1)(q - 1)
# 
# Input: p (integer, r0), q (integer, r1)
# Output: totient (integer, r0)
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

# End totient function


