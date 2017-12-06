# fileio.asm
	
.data

#Must use accurate file path.
#These file paths are EXAMPLES, 
#should not work for you
str1:	.asciiz "/home/simon/COMP/COMP273/comp273f2017simz/Assignment4/test1.txt"
str2:	.asciiz "/home/simon/COMP/COMP273/comp273f2017simz/Assignment4/test2.txt"
str3:	.asciiz "test.pgm"	#used as output

buffer:  .space 2048		# buffer for upto 2048 bytes

error:	.asciiz "File I/O error\n"

	.text
	.globl main

main:	la $a0,str1		#readfile takes $a0 as input
	jal readfile

	la $a0, str3		#writefile will take $a0 as file location
	la $a1,buffer		#$a1 takes location of what we wish to write.
	jal writefile

	li $v0,10		# exit
	syscall

################################################################################

readfile:

#Open the file to be read,using $a0
	li $v0, 13		# syscall to open file (path already in $a0)
	li $a1, 0		# Flag to read file
	syscall
	move $t0, $v0		# Copy file descriptor to $t0
#Conduct error check, to see if file exists
	bge $t0, $zero, Read1	# Error if FD < 0 else go to read file
	li $v0, 4		# Print error message
	la $a0, error
	syscall
	li $v0,10		# Exit
	syscall

# You will want to keep track of the file descriptor*

# read from file
# use correct file descriptor, and point to buffer
# hardcode maximum number of chars to read
# read from file

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

# address of the ascii string you just read is returned in $v1.
# the text of the string is in buffer
# close the file (make sure to check for errors)

Close1:	move $t1, $v0		# Copy # chars read to $t1
	li   $v0, 16		# syscall to close file
	move $a0, $t0		# Pass file descriptor
	syscall
	
	move $v0, $t1		# Copy back # chars read to return
	la $v1, buffer		# Return string address
	jr $ra

################################################################################

writefile:
#open file to be written to, using $a0.
#write the specified characters as seen on assignment PDF:
#P2
#24 7
#15
#write the content stored at the address in $a1.
#close the file (make sure to check for errors)
