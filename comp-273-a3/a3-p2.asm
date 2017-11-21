# Name:		Simon Zheng
# Student ID:	260744353

# Problem 2 - Dr. Ackermann or: How I Stopped Worrying and Learned to Love Recursion
###########################################################
.data
error: .asciiz "error: m, n must be non-negative integers\n"

.text 
###########################################################
main:
# get input from console using syscalls

# compute A on inputs 
	jal A
# print value to console and exit with status 0

###########################################################
# int A(int m, int n)
# computes Ackermann function
A: 
	add $t0,$a0,$zero	# Put "m" into $t0
	add $t1,$a1,$zero	# "n" into $t1
	
Base:	beq $t0,0,End		# If m = 0 go to return
	blt $t0,0,End		# If m < 0 go to return (just in case)
	
Mgt0:	addi $sp,$sp,-12	# Add space on stack for 3 words
	sw $t0,0($sp)		# Store m on stack
	sw $t1,4($sp)		# Store n on stack
	sw $ra,8($sp)		# Store $ra on stack
	
Nis0:	bne $t1,0,Ngt0		# Else if n != 0 then go to Ngt0 instead
	
	sub $a0,$t0,$t1		# $a1 is already "n" and new $a0 is now "m-n"
	jal gcd			# Recursive call
	
	j RecEnd		# Jump to pop stack and End

Ngt0:	sub $a1,$t1,$t0		# $a0 is already "m" and new $a1 is now "n-m"
	jal gcd			# Recursive call
	
RecEnd:	lw $ra,0($sp)		# Load $ra from stack
	addi $sp,$sp,4		# Move stack pointer back
	
End:	add $v0,$t1,1		# Return n + 1
	jal check
	jr $ra
	
###########################################################
# void check(int m, int n)
# checks that n, m are natural numbers
# prints error message and exits with status 1 on fail
check:
	jr $ra
