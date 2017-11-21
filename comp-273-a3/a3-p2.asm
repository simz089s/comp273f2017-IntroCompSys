# Name:		Simon Zheng
# Student ID:	260744353

# Problem 2 - Dr. Ackermann or: How I Stopped Worrying and Learned to Love Recursion
###########################################################
.data
error: .asciiz "error: m, n must be non-negative integers\n"
prompt1: .asciiz "Enter m\n"
prompt2: .asciiz "Enter n\n"

.text 
###########################################################
main:
# get input from console using syscalls
	li $v0, 4
	la $a0, prompt1
	syscall
	
	li $v0,5		# Read m
	syscall
	add $a0,$v0,$zero	# Move m to $a0
	
	li $v0,4
	la $a0, prompt2
	syscall
	
	li $v0,5		# Read n
	syscall
	add $a1,$v0,$zero	# Move n to $a1
# compute A on inputs 
	jal A
# print value to console and exit with status 0
	add $a0,$v0,$zero	# Print result
	li $v0,1
	syscall
	
Exit:	li $v0,10
	syscall

###########################################################
# int A(int m, int n)
# computes Ackermann function
A: 
	add $t0,$a0,$zero	# Put "m" into $t0
	add $t1,$a1,$zero	# Put "n" into $t1
	
Check1:	bne $t0,0,Check2	# If m != 0 then go to next check else if m = 0 then go to return n + 1
	add $v0,$t1,1		# Return n + 1
	j End
Check2:	blt $t0,0,End		# If m < 0 go to return (just in case)
	
Mgt0:	addi $sp,$sp,-16	# Add space on stack for 4 words
	sw $t0,0($sp)		# Store m on stack
	sw $t1,4($sp)		# Store n on stack
	sw $v0,8($sp)		# Store $v0 on stack
	sw $ra,12($sp)		# Store $ra on stack
	
Nis0:	bne $t1,0,Ngt0		# Else if n != 0 then go to Ngt0 instead
	
	addi $a0,$t0,-1		# $a0 is now "m - 1"
	addi $a1,$zero,1	# $a1 is 1
	jal A			# Recursive call
	
	j RecEnd		# Keep returning from recursive calls

Ngt0:	blt $t1,0,End		# Else if not n > 0 then End
	
	add $a0,$t0,$zero	# $a0 is m
	addi $a1,$t1,-1		# $a1 is n - 1
	jal A			# Recursive call
	
	add $t2,$v0,$zero	# Move result into $t2
	#lw $v0,8($sp)		# Restore $v0 from stack
	lw $t0,0($sp)		# Get current m back into $t0 from stack
	addi $a0,$t0,-1		# $a0 is m - 1
	add $a1,$t2,$zero	# $a1 is $t2
	jal A			# Recursive call
	
RecEnd:	#lw $t0,0($sp)		# Load m from stack
	#lw $t1,4($sp)		# Load n from stack
	#lw $v0,8($sp)		# Load $v0 from stack
	lw $ra,12($sp)		# Load $ra from stack
	addi $sp,$sp,16		# Move stack pointer back down
	
End:	#jal check
	jr $ra			# Result in $v0
	
###########################################################
# void check(int m, int n)
# checks that n, m are natural numbers
# prints error message and exits with status 1 on fail
check:
	jr $ra
