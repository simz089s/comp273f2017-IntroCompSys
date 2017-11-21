#StudentID:	260744353
#Name:		Simon Zheng

.data

prompt:		.asciiz "Input characters:\n"
original:	.asciiz "\nOriginal linked list\n"
reversed:	.asciiz "\nreversed linked list\n"

.text
#There are no real limit as to what you can use
#to implement the 3 procedures EXCEPT that they
#must take the specified inputs and return at the
#specified outputs as seen on the assignment PDF.
#If convention is not followed, you will be
#deducted marks.

main:
#build a linked list
	jal build		# Build list
	add $s0, $zero, $v1	# Move returned head address into $s0
	
#print "Original linked list\n"
	li $v0, 4
	la $a0, original
	syscall
#print the original linked list
	add $a0, $zero, $s0	# Move head address into $a0 for print
	jal print

#reverse the linked list
	add $a1, $zero, $s0	# Pass head address as argument to reverse
	jal reverse
	add $s0, $zero, $v1	# Store returned address of reversed head into $s0
	
#On a new line, print "reversed linked list\n"
	li $v0, 4
	la $a0, reversed
	syscall
#print the reversed linked list
	add $a0, $zero, $s0	# Move head address into $a0 for print
	jal print

#terminate program
End:	li $v0, 10
	syscall

###############################################################################

malloc:
	li $v0, 9	# Malloc num of bytes already in $a0
	syscall
	
	jr $ra		# Address in $v0

build:
#continually ask for user input UNTIL user inputs "*"
	li $v0, 4
	la $a0, prompt
	syscall
	
#FOR EACH user inputted character inG, create a new node that hold's inG AND an address for the next node
Head1:	li $v0, 12		# Read first character
	syscall
	
	beq $v0, 42, Done1	# Stop if *
	
	add $s1, $zero, $v0	# Save character into $s1 (Storing things in $s because of jal malloc)
	
	add $s2, $zero, $ra	# Save $ra
	li $a0, 8		# 4 bytes for 1 byte character (offset must be word multiples it seems) and 4 bytes for address of next node
	jal malloc
	add $ra, $zero, $s2	# Restore $ra
	add $s0, $zero, $v0	# Move result adress of new head node to $s0
	add $s3, $zero, $v0	# Move result adress of new head node to $s3
	sb $s1, 0($s3)		# Store first character into head node
	
Tail1:	li $v0, 12		# Read a character
	syscall
	
	beq $v0, 42, Done1	# Stop if *
	
	add $s1, $zero, $v0	# Save character into $s1
	
	add $s2, $zero, $ra	# Save $ra
	li $a0, 8		# 4 bytes for character and 4 bytes for address of next node
	jal malloc
	add $ra, $zero, $s2	# Restore $ra
	
	sw $v0, 4($s3)		# Point previous node's next address to new node
	add $s3, $zero, $v0	# Move adress of new node to $s3 (new next node becomes current node)
	sb $s1, 0($s3)		# Store character into new node
	sw $zero, 4($s3)	# Point new node's next address to null
	
	j Tail1			# Loop
	
#at the end of build, return the address of the first node to $v1

Done1:	add $v1, $zero, $s0	# Return head address with $v1
	jr $ra
	
###############################################################################

print:
#$a0 takes the address of the first node
Head2:	add $t1, $zero, $a0	# Move head address into $t1
	
#prints the contents of each node in order
Tail2:	lb $t0, 0($t1)		# Load character into $t0
	li $v0, 11		# Print character
	add $a0, $zero, $t0	# in $t0
	syscall
	
	lw $t2, 4($t1)		# Load adress of next node into $t2
	add $t1, $zero, $t2	# Move address of next node back into $t1
	
	bne $t1, $zero, Tail2	# Loop if next node not null else finish
	
Done2:	jr $ra

###############################################################################

reverse:
#$a1 takes the address of the first node of a linked list
	
				# $t0 is previous node address, $t1 is current node address, $t2 is next node address
	
	add $t1, $zero, $a1	# Start with first head node as current node
	or $t0, $zero, $zero	# and null as previous node
	
#reverses all the pointers in the linked list
Loop:	beq $t1, $zero, Done3	# If current node is null then finish
	
	lw $t2, 4($t1)		# Save next node address into $t2
	sw $t0, 4($t1)		# Put saved address of previous node as new next node
	
	add $t0, $zero, $t1	# Set current node as new previous node
	add $t1, $zero, $t2	# Go to next node (set next node as new current node)
	
	j Loop

#$v1 returns the address
Done3:	add $v1, $zero, $t0	# At this point $t0 stores the address of the last node which is the head of reversed list
	jr $ra
