# Program to capitalize the first letter of a string

	.data		# variable declarations follow this line
str: 	.asciiz "Enter the string to capitalize: "
                 
														
	.text		# instructions follow this line	
																	                    
main:     		# indicates start of code to test "upper" the procedure
	la $a0,str		# Prompt input string to capitalize
	li $v0,4
	syscall
	
	la $a1,128		# Max 127 characters and null terminating char
	li $v0,8		# Read string
	syscall
	
	add $s0,$a0,$zero	# Save string address in $s0
	jal upper
	
	la $a0,0($s0)
	li $v0,4
	syscall
	
	li $v0,10		# Exit
	syscall

upper:	     			# the "upper" procedure
	add $t0,$a0,$zero	# Put argument string address into temporary address
	addi $t0,$t0,1		# Start at the next char
Loop:	lb $t1,0($t0)		# Load first character from string address into $t1
	lb $t2,-1($t0)		# Load previous char into $t2
	
	bne $t2,32,Incr		# If prev char is not space then skip else check if lower case letter
	bl
	
Incr:	addi $t0,$t0,1		# Increment string address
	j Loop


									
# End of program
