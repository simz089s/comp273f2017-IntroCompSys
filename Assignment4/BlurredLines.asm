
.data

#Must use accurate file path.
#These file paths are EXAMPLES, 
#should not work for you
str1:	.asciiz "C:/Users/Simon/Desktop/Prog/COMP 273/comp273f2017simz/Assignment4/test1.txt"
str3:	.asciiz "test-blur.pgm"	#used as output

buffer:  .space 2048		# buffer for upto 2048 bytes
newbuff: .space 2048

.align 2			# Align to word

iarray:	.space 672		# 672 bytes = 168 words = 24*7 integers
oarray:	.space 672		# Averaged array

error:	.asciiz "File I/O error\n"
header:	.ascii "P2\n24 7\n15\n"

	.text
	.globl main

main:	la $a0,str1		#readfile takes $a0 as input
	jal readfile


	la $a1,buffer		#$a1 will specify the "2D array" we will be averaging
	la $a2,newbuff		#$a2 will specify the blurred 2D array.
	jal blur


	la $a0, str3		#writefile will take $a0 as file location
	la $a1,newbuff		#$a1 takes location of what we wish to write.
	jal writefile

	li $v0,10		# exit
	syscall

################################################################################

readfile:
#done in Q1

	li $v0, 13		# syscall to open file (path already in $a0)
	li $a1, 0		# Flag to read file
	syscall
	move $t0, $v0		# Copy file descriptor to $t0

	bge $t0, $zero, Read1	# Error if FD < 0 else go to read file
	li $v0, 4		# Print error message
	la $a0, error
	syscall
	li $v0,10		# Exit
	syscall

Read1:	li $v0, 14		# syscall to read file
	move $a0, $t0		# Pass file descriptor 
	la $a1, buffer		# Read to buffer
	li $a2, 2048		# Buffer size for max chars
	syscall
	
	bge $v0, $zero, Close1	# Error if # chars read < 0 else go to close file
	li $v0, 4		# Print error message
	la $a0, error
	syscall
	li $v0,10		# Exit
	syscall

Close1:	move $t1, $v0		# Copy # chars read to $t1
	li $v0, 16		# syscall to close file
	move $a0, $t0		# Pass file descriptor
	syscall
	
	bge $t0, $zero, End1	# Error if FD < 0 else go to end subroutine
	li $v0, 4		# Print error message
	la $a0, error
	syscall
	li $v0,10		# Exit
	syscall
	
End1:	move $v0, $t1		# Copy back # chars read to return
	la $v1, buffer		# Return string address
	jr $ra

################################################################################

blur:
#use real values for averaging.
#HINT set of 8 "edge" cases.
#The rest of the averaged pixels will 
#default to the 3x3 averaging method
#we will return the address of our
#blurred 2D array in #v1
	
	addi $sp, $sp, 8	# Add space on stack to put buffers addresses
	sw $a1, 0($sp)		# Store buffer address on stack
	sw $a2, 4($sp)		# Store newbuff address on stack
	
	move $t1, $a1		# Copy buffer address to $t1
	la $t3, iarray		# Load array address to $t3
	
R2Array:xor $t4, $t4, $t4	# Zero out $t4 to be used as running sum per int
	xor $t5, $t5, $t5	# $t5 for int count
	
Loop3:	lb $t7, 0($t1)		# Put char of buff into $t7
	blt $t7, 48, NotNum	# Branch if not in range of number ASCII
	bgt $t7, 57, NotNum
#	beq $t7, 0, Avg		# Branch if null
NumL:	beq $t5, 168, Avg	# Go to average when read everything into array
	
	addi $t7, $t7, -48	# Convert ASCII digit to int digit
	mul $t4, $t4, 10	# Multiply running sum by 10 for positional notation trick
	add $t4, $t4, $t7	# Add digit as unit to running sum
	
Incr:	addi $t1, $t1, 1	# Increment buffer pointer
	j Loop3			# Jump to loop
	
NotNum:	sw $t4, 0($t3)		# Hit non numeral char which separates ints so put previous running sum int into array
	addi $t3, $t3, 4	# Increment array pointer (aligned by word)
	addi $t5, $t5, 1	# Increment int count $t5 for new number found
	xor $t4, $t4, $t4	# Reset running sum $t4
NaNL:	beq $t5, 168, Avg	# Go to average when read everything into array
	addi $t1, $t1, 1	# Increment buffer pointer (by a char byte)
	lb $t7, 0($t1)		# Put char of buffer pointer into $t7
	blt $t7, 48, NaNL	# Loop if still not number ASCII
	bgt $t7, 57, NaNL
	
	j NumL			# Go back to main loop
	
Avg:	xor $t5, $t5, $t5	# Reset $t5 for column count
	xor $t6, $t6, $t6	# $t6 for row count
	la $t2, oarray		# Load averaged array address to $t2
	la $t3, iarray		# Reload initial array to reset pointer $t3
	
End3:	jr $ra

################################################################################

writefile:
#done in Q1

#	move $t1, $s0		# Copy # chars read to $t1 again
	move $t2, $a1		# Copy buffer address to $t2
	
	li $v0, 13		# syscall to open file (path already in $a0)
	li $a1, 1		# Flag to write file
	syscall
	move $t0, $v0		# Copy file descriptor to $t0
	
	bge $t0, $zero, Write2	# Error if FD < 0 else go to write file
	li $v0, 4		# Print error message
	la $a0, error
	syscall
	li $v0,10		# Exit
	syscall
	
Write2:	li $v0, 15		# syscall to write file
	move $a0, $t0		# Pass file descriptor
	la $a1, header		# Write header
	li $a2, 11		# Num of chars of header to write
	syscall
	
	li $v0, 15		# syscall to write file
	move $a0, $t0		# Pass file descriptor
	la $a1, buffer		# Write from buffer address
	li $a2, 2048		# Buffer size for max # chars to write
	syscall
	
	bge $v0, $zero, Close2	# Error if # chars written < 0 else go to close file
	li $v0, 4		# Print error message
	la $a0, error
	syscall
	li $v0,10		# Exit
	syscall
	
Close2:	move $t1, $v0		# Copy # chars written to $t1
	li $v0, 16		# syscall to close file
	move $a0, $t0		# Pass file descriptor
	syscall
	
	bge $t0, $zero, End2	# Error if FD < 0 else go to end subroutine
	li $v0, 4		# Print error message
	la $a0, error
	syscall
	li $v0,10		# Exit
	syscall
	
End2:	move $v0, $t1		# Copy back # chars written to return
#	la $v1, buffer		# Return string address
	jr $ra
