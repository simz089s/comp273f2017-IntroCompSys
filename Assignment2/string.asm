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
	
	jal upper		# Call "upper" procedure with string address already in $a0 from read
	
	add $s0,$v0,$zero	# Save return string address (may be a bit be redundant)
	la $a0,0($s0)		# Put changed string as print syscall argument
	li $v0,4		# Print string
	syscall
	
	li $v0,10		# Exit
	syscall

upper:	     			# the "upper" procedure
	add $s0,$a0,$zero	# Save original string address into $s0
	add $t0,$s0,$zero	# Put argument string address into temporary address
	
	lb $t1,0($t0)		# Load first character from string address into $t1
	blt $t1,97,Incr		# Special case for the first char
	bgt $t1,122,Incr	# which is not preceded by a space
	addi $t1,$t1,-32	# This part is identical to the Loop body
	sb $t1,0($t0)		# Refer to comments there
	
Loop:	lb $t1,0($t0)		# Load first character from string address into $t1
	beq $t1,0,Done		# End procedure when null byte reached
	lb $t2,-1($t0)		# Load previous char into $t2
	
	bne $t2,32,Incr		# If prev char is not space then skip else check if lower case letter
	blt $t1,97,Incr		# If current char is not a lower case letter then skip
	bgt $t1,122,Incr
	addi $t1,$t1,-32	# To upper case
	sb $t1,0($t0)		# Store capitalised letter back into string
	
Incr:	addi $t0,$t0,1		# Increment string address
	j Loop

Done:	add $v0,$s0,$zero	# Return original string address
	jr $ra
									
# End of program
