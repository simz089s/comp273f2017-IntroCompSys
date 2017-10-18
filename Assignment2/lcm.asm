# Program to calculate the least common multiple of two numbers

	.data		# variable declarations follow this line
first: 	.word 10	# the first integer
second: .word 15    	# the second integer                  
														
	.text		# instructions follow this line	
																	                    
main:     		# indicates start of code to test lcm the procedure




lcm:	     		# the "lcm" procedure
	lw $t0,0($a0)		# a (bigger number)	Load arguments into
	lw $t1,0($a1)		# b (smaller number)	temporary registers
	add $t2,$zero,$zero	# Result to be returned
	
Loop:	add $t2,$t2,$t0		# Add a to result
	div $t2,$t1		# Divide result by b
	mfhi $t3
	bne $t3, $zero, Loop	# If remainder is 0 then result is divisible by b and we're done else loop
	
	sw $v0,0($t2)		# Prepare to return
	
	










									
# End of program
