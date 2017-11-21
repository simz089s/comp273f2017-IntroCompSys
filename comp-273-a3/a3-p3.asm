# Name:		Simon Zheng
# Student ID:	260744353

# Problem 3
# Numerical Integration with the Floating Point Coprocessor
###########################################################
.data
N: .word 100
a: .float 0
b: .float 1
error: .asciiz "error: must have low < hi\n"

.text 
###########################################################
main:
	# set argument registers appropriately
	l.s $f12,a
	l.s $f13,b
	la $a0,ident
	# call integrate on test function 
	jal integrate
	# print result and exit with status 0
	li $v0,2
	#lw $f12,$f12
	syscall
	li $v0,17		# Exit 0
	xor $a0,$a0,$a0
	syscall

###########################################################
# float integrate(float (*func)(float x), float low, float hi)
# integrates func over [low, hi]
# $f12 gets low, $f13 gets hi, $a0 gets address (label) of func
# $f0 gets return value
integrate: 
	add $s0,$ra,$zero	# Save return address
	jal check
	add $ra,$s0,$zero	# Restore return address
	
	# initialize $f4 to hold N
	# since N is declared as a word, will need to convert 
	
	jr $ra

###########################################################
# void check(float low, float hi)
# checks that low < hi
# $f12 gets low, $f13 gets hi
# # prints error message and exits with status 1 on fail
check:
	c.lt.s $f12,$f13
	bc1t Checked		# Return if $f12 < $f13
	li $v0,4		# Print error message
	la $a0,error
	syscall
	li $v0,17		# Exit 1
	addi $a0,$zero,1
	syscall
Checked:jr $ra

###########################################################
# float ident(float x) { return x; }
# function to test your integrator
# $f12 gets x, $f0 gets return value
ident:
	mov.s $f0, $f12
	jr $ra
