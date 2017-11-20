#StudentID:	260744353
#Name:		Simon Zheng

.data

prompt:		.asciiz "Input characters:\n"
original:	.asciiz "Original linked list\n"
reversed:	.asciiz "reversed linked list\n"

.text
#There are no real limit as to what you can use
#to implement the 3 procedures EXCEPT that they
#must take the specified inputs and return at the
#specified outputs as seen on the assignment PDF.
#If convention is not followed, you will be
#deducted marks.

main:
#build a linked list
	jal build

#print "Original linked list\n"
#print the original linked list

#reverse the linked list
#On a new line, print "reversed linked list\n"
#print the reversed linked list

#terminate program
	li $v0, 10
	syscall

malloc:
	li $v0, 9	# Malloc num of bytes already in $a0
	syscall
	
	jr $ra

build:
#continually ask for user input UNTIL user inputs "*"
	li $v0, 4
	la $a0, prompt
	syscall
	
Head:	li $v0, 12		# Read a character
	syscall
	
	beq $v0, 42, Done1	# Stop if *
	
	add $t0, $zero, $v0	# Store character in $t0
	
	add $t2, $zero, $ra	# Save $ra
	li $a0, 5		# 1 byte for character and 4 bytes for address of next node
	jal malloc
	add $ra, $zero, $t2	# Restore $ra
	add $t1, $zero, $v0	# Move result adress of new node head to $t1
	add $s0, $zero, $v0	# Move result adress of new node head to $s0
	
Tail:	li $v0, 12		# Read a character
	syscall
	
	beq $v0, 42, Done1	# Stop if *
	
	add $t0, $zero, $v0	# Store character in $t0
	
	add $t2, $zero, $ra	# Save $ra
	li $a0, 5		# 1 byte for character and 4 bytes for address of next node
	jal malloc
	add $ra, $zero, $t2	# Restore $ra
	
	sw $v0, 4($t1)		# Point previous node's next address to new node
	add $t1, $zero, $v0	# Move adress of new node to $t1
	sb $t0, 0($t1)		# Store character into new node
	sw $zero, 4($t1)	# Point new node's next address to null
	
	li $v0, 11		# DEBUG
	lb $a0, 0($t1)		# DEBUG
	syscall			# DEBUG
	
	j Tail			# Loop
	
#FOR EACH user inputted character inG, create a new node that hold's inG AND an address for the next node
#at the end of build, return the address of the first node to $v1

Done1:	add $v0, $zero, $s0	# Return head address
	jr $ra

print:
#$a0 takes the address of the first node
#prints the contents of each node in order

reverse:
#$a1 takes the address of the first node of a linked list
#reverses all the pointers in the linked list
#$v1 returns the address
