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
	#mov.s $f0,$f0
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
	
	# initialize $f4 to hold N
	# since N is declared as a word, will need to convert 
	l.s $f4,N
	cvt.s.w $f4,$f4
	sub.s $f6,$f13,$f12	# Put b-a into $f6 temp reg
	div.s $f20,$f6,$f4	# Put delta(x)=(b-a)/N into $f20
	mtc1 $zero,$f22		# Set i counter to 0
	mov.s $f24,$f12		# Save a into $f24
	mov.s $f26,$f4		# Save N into $f24
	
Loop:	c.eq.s $f24,$f26	# Check if i = N
	bc1t Done		# Finish if i = N
	
	# Calculate midpoint D(x)/2+(a+x_0?) and then just keep adding D(x) (is counter i even needed?)
	#mul.s $f6,$f22,$f20	# Calculate x_i into $f6 (i * D(x))
	#add.s $f6,$f24,$f6	# a + i * D(x)
	#add.s $f22,$f22,1	# Increment i
	#mul.s $f8,$f22,$f20	# Calculate x_i+1 into $f8 (i * D(x))
	#add.s $f8,$f24,$f6	# a + i * D(x)
	#sub.s $f10,$f8
	jalr $a0		# Jump to function
	
	
Done:	add $ra,$s0,$zero	# Restore return address
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
