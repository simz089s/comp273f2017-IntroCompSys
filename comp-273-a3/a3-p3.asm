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
	add $s1,$a0,$zero	# Save function address
	jal check
	
	# initialize $f4 to hold N
	# since N is declared as a word, will need to convert 
	l.s $f4,N
	cvt.s.w $f4,$f4
	sub.s $f6,$f13,$f12	# Put b-a into $f6 temp reg
	div.s $f20,$f6,$f4	# Put delta(x)=(b-a)/N into $f20
	mtc1 $zero,$f22		# Set i counter to 0
	mtc1 $zero,$f28		# Set sum to 0 in $f28
	mov.s $f24,$f4		# Save N into $f24
	mov.s $f26,$f12		# Save starting x_i (x_0 = a) into $f26
	addi $t0,$zero,2	# Get 2 to divide by 2
	mtc1 $f6,$t0		# Move to float processors
	cvt.s.w $f6,$f6		# Convert to float
	div.s $f6,$f20,$f6	# Divide D(x) by 2 and put into $f6
	add.s $f26,$f26,$f6	# x_i + D(x)/2
	addi $t0,$zero,1	# Get 1 to increment
	mtc1 $f6,$t0		# Move to float processors
	cvt.s.w $f30,$f6	# Convert to float and put in $f30
	
Loop:	c.eq.s $f22,$f24	# Check if i = N
	bc1t Done		# Finish if i = N
	
	# Calculate midpoint D(x)/2+(a+x_0?) and then just keep adding D(x) (is counter i even needed?)
	mov.s $f12,$f26		# Calculate mid point of x_i
	jalr $s1		# Jump to function
	mul.s $f6,$f20,$f0	# D(x) * f(x_i) into $f6
	add.s $f28,$f28,$f6	# sum = sum + $f6
	
	add.s $f22,$f22,$f30	# Increment i
	add.s $f26,$f26,$f20	# Increment x_i by D(x)
	j Loop
	
Done:	mov.s $f0,$f28		# Return sum
	add $ra,$s0,$zero	# Restore return address
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
