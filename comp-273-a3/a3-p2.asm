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
	add $t1,$a1,$zero	# Put "n" into $t1
	
Base:	beq $t0,0,End		# If m = 0 go to return
	blt $t0,0,End		# If m < 0 go to return (just in case)
	
Mgt0:	addi $sp,$sp,-12	# Add space on stack for 3 words
	sw $t0,0($sp)		# Store m on stack
	sw $t1,4($sp)		# Store n on stack
	sw $ra,8($sp)		# Store $ra on stack
	
Nis0:	bne $t1,0,Ngt0		# Else if n != 0 then go to Ngt0 instead
	
	addi $a0,$t0,-1		# $a0 is now "m - 1"
	addi $a1,$zero,1	# $a1 is 1
	jal A			# Recursive call
	
	j RecEnd		# Keep returning from recursive calls

Ngt0:	bne $t1,0,Ngt0		# Else if not n > 0 then End
	
	add $a0,$t0,$zero	# $a0 is m
	addi $a1,$t1,-1		# $a1 is n - 1
	jal A			# Recursive call
	
	add $t2,$v0,$zero	# Move result into $t2
	lw $t0,0($sp)		# Get current m back into $t0 from stack
	addi $a0,$t0,-1		# $a0 is m - 1
	addi $a1,$t2,$zero	# $a1 is $t2
	jal A			# Recursive call
	
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
