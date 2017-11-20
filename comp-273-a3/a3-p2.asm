# Name:
# Student ID: 

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
	jal check
	jr $ra
	
###########################################################
# void check(int m, int n)
# checks that n, m are natural numbers
# prints error message and exits with status 1 on fail
check:
	jr $ra