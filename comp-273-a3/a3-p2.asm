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
	li $v0,4
	la $a0,prompt1
	syscall
	
	li $v0,5		# Read m
	syscall
	add $t0,$v0,$zero	# Move m to $t0
	
	li $v0,4
	la $a0,prompt2
	syscall
	
	li $v0,5		# Read n
	syscall
	add $t1,$v0,$zero	# Move n to $t1
# compute A on inputs 
	add $a0,$t0,$zero
	add $a1,$t1,$zero
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
	
	addi $sp,$sp,-12	# Add space on stack for 4 words
	sw $t0,0($sp)		# Store m on stack
	sw $t1,4($sp)		# Store n on stack
	sw $ra,8($sp)		# Store $ra on stack
	
Check:	jal check		# Check if m and n are natural numbers
	beq $v0,$zero,RecEnd	# If m is not a natural number then go to return
	
	lw $t0,0($sp)		# Restore m from stack
	lw $t1,4($sp)		# Restore n from stack
	
Check1:	bne $t0,0,Nis0		# If m != 0 then go to recursive case
	add $v0,$t1,1		# If m = 0 then return n + 1
	j RecEnd
	
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
	lw $t0,0($sp)		# Get current m back into $t0 from stack
	addi $a0,$t0,-1		# $a0 is m - 1
	add $a1,$t2,$zero	# $a1 is $t2
	jal A			# Recursive call
	
RecEnd:	lw $ra,8($sp)		# Restore $ra from stack
	addi $sp,$sp,12		# Move stack pointer back down
	
End:	jr $ra			# Result in $v0
	
###########################################################
# void check(int m, int n)
# checks that n, m are natural numbers
# prints error message and exits with status 1 on fail
check:
	add $t0,$a0,$zero	# Put "m" into $t0
	add $t1,$a1,$zero	# Put "n" into $t1
	
	xor $v0,$v0,$v0		# Initially assume false
	
CheckM:	blt $t0,$zero,Error	# If m is not natural then print error and return false else check n
CheckN: blt $t1,$zero,Error	# If n is not natural then print error and return false else return true
	addi $v0,$zero,1
	j Checked
	
Error:	li $v0,4
	la $a0,error
	syscall
	j Checked
	
Checked:jr $ra
