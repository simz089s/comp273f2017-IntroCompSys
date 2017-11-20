# Name:
# Student ID: 

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
	
	# call integrate on test function 
	
	# print result and exit with status 0
	

###########################################################
# float integrate(float (*func)(float x), float low, float hi)
# integrates func over [low, hi]
# $f12 gets low, $f13 gets hi, $a0 gets address (label) of func
# $f0 gets return value
integrate: 
	jal check
	
	# initialize $f4 to hold N
	# since N is declared as a word, will need to convert 
	
	jr $ra

###########################################################
# void check(float low, float hi)
# checks that low < hi
# $f12 gets low, $f13 gets hi
# # prints error message and exits with status 1 on fail
check:
	jr $ra

###########################################################
# float ident(float x) { return x; }
# function to test your integrator
# $f12 gets x, $f0 gets return value
ident:
	mov.s $f0, $f12
	jr $ra
