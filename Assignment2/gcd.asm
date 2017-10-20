# Program to implement the Dijkstra's GCD algorithm

	.data		# variable declarations follow this line
str1: 	.asciiz "Enter the first integer: "
str2: 	.asciiz "Enter the second integer: "                  
														
	.text		# instructions follow this line	
	
main:     		# indicates start of code to test lcm the procedure
	la $a0,str1		# Prompt first number "a"
	li $v0,4
	syscall
	li $v0,5		# Read first int "a"
	syscall
	add $s0,$v0,$zero	# Save first int "a" into $s0
	
	la $a0,str2		# Prompt second int "b"
	li $v0,4
	syscall
	li $v0,5		# Read second int "b"
	syscall
	add $s1,$v0,$zero	# Save second int "b" into $s1
	
	add $a0,$s0,$zero	# Put "a" as first argument
	add $a1,$s1,$zero	# Put "b" as second argument
	jal gcd			# Call "gcd" procedure
	
	add $s1,$v0,$zero	# Save return result from gcd procedure
	add $a0,$s1,$zero	# Put result as print argument
	li $v0,1		# Call print
	syscall
	
	li $v0,10		# Exit
	syscall
																	                    
																	                    																	                    
																	                    																	                    																	                    																	                    
gcd:	     		# the "gcd" procedure
	add $t0,$a0,$zero	# Put first int argument "a" into temp register
	add $t1,$a1,$zero	# Same for "b"
	
Base:	bne $t0,$t1,Start	# If a != b go to Start
	add $v0,$t0,$zero	# else return a
	j End
	
Start:	addi $sp,$sp,-12	# Add space on stack for three words, a b and $ra
	sw $ra,8($sp)		# Store $ra first
	sw $t1,4($sp)		# Store "b" second
	sw $t0,0($sp)		# Store "a" third
	
Elif:	blt $t0,$t1,Else	# Else if a > b
	
	sub $a0,$t0,$t1		# $a1 is already "b" and new $a0 is now "a-b"
	jal gcd			# Recursive call
	
	j RecEnd		# Jump to pop stack and End

Else:	sub $a1,$t1,$t0		# $a0 is already "a" and new $a1 is now "b-a"
	jal gcd			# Recursive call
	
RecEnd:	lw $t0,0($sp)		# Load "a" first
	lw $t1,4($sp)		# Load "b" second
	lw $ra,8($sp)		# Load $ra third
	addi $sp,$sp,12		# Move stack pointer back
	
End:	jr $ra			# Return from call
									
# End of program
