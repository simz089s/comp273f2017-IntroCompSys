
.data

#Must use accurate file path.
#These file paths are EXAMPLES, 
#should not work for you
str1:	.asciiz "/Users/McGill/Courses/COMP-273/assignments/2017/Assign4/test1.txt"
str3:	.asciiz "test-blur.pgm"	#used as output

buffer:  .space 2048		# buffer for upto 2048 bytes
newbuff: .space 2048

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

readfile:
#done in Q1


blur:
#use real values for averaging.
#HINT set of 8 "edge" cases.
#The rest of the averaged pixels will 
#default to the 3x3 averaging method
#we will return the address of our
#blurred 2D array in #v1

writefile:
#done in Q1