#Calculator
#You will recieve marks based 
#on functionality of your calculator.
#REMEMBER: invalid inputs are ignored.


#Have fun!

.data

buffer:  .space 2048		# buffer for upto 2048 bytes

IniPrmpt:.asciiz "Calculator for MIPS\npress �c� for clear and �q� to quit:\n"

	.text
	.globl main

#TODO:
#main procedure, that will call your calculator

main:	
	li $v0, 10		# Exit
	syscall

#calculator procedure, that will deal with the input
	#2 cases you must consider:

	#  Number Operation Number <enter is pressed>
	#  Must display the result on the screen

	#  Operation Number <enter is pressed>
	#  uses prior result as the first number
	#  Returns the new result to the display


#driver for getting input from MIPS keyboard


#driver for putting output to MIPS display
