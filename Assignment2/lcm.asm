# Program to calculate the least common multiple of two numbers

	.data		# variable declarations follow this line
first: 	.word 10	# the first integer
second: .word 15    	# the second integer                  
														
	.text		# instructions follow this line	
																	                    
main:     		# indicates start of code to test lcm the procedure
	la $t0,first		# Load "first" and "second"
	la $t1,second		# pseudo-instructions
	lw $a0,0($t0)		# Put "first" and "second" as arguments
	lw $a1,0($t1)		# for "lcm" procedure
	jal lcm			# Call to "lcm" procedure
	
	add $s2,$v0,$zero	# Get "lcm" result
	
	add $a0,$s2,$zero	# Put result into syscall argument
	li $v0,1		# Print int syscall
	syscall

	li $v0,10		# Exit syscall
	syscall

lcm:	     		# the "lcm" procedure
	add $s0,$a0,$zero	# "a"	Put arguments into saved registers (used through entire procedure)
	add $s1,$a1,$zero	# "b"	More efficient if the bigger number (assuming "a") is the one that keeps getting added
	add $t2,$zero,$zero	# Register with result to be returned "initialized" as 0
	
Loop:	add $t2,$t2,$s0		# Add "a" to result
	div $t2,$s1		# Divide result by "b"
	mfhi $t3		# Put remainder in $t3
	bne $t3,$zero,Loop	# If remainder is 0 then result is divisible by "b" and we're done else loop
	
	add $v0,$t2,$zero	# Put result as return value
	jr $ra			# Return

									
# End of program
