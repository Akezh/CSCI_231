.data 
	Arr: .word 21 20 51 83 20 20
	length: .word 6
	x:	 .word 20
	y: 	 .word 5
	index:	.word 0
	space: .asciiz " "
	line: .asciiz "\n"

.text
	main:	
		la $a0, Arr			
		lw $a1, length
		lw $a2, x
		lw $a3, y
		
		jal printArrInt		# Call printArrInt function
		jal replace			# Call replace function
		jal printArrInt		# Call printArrInt function
		
		li $v0, 10			# Code 10 to exit the program
		syscall
		
	replace:
		move $t0, $a0	# Array parameter value gets $t0
		move $t1, $a1	# length parameter value gets $t1
		move $t2, $a2	# X parameter value gets $t2
		move $t3, $a3	# Y parameter value gets $t3
		lw $t5, index 		# Local iterator variable
		
	replaceLoop:
		lw $t4, 0($t0)
		
		beq $t4, $t2, replaceNumber
		addi $t0, $t0, 4			# get next element of array
		addi $t5, $t5, 1			# iterator++
				
		bne $t5, $t1, replaceLoop	# while iterator does not equal to length jump to replaceLoop
				
		jr $ra			# go to main function
		
	replaceNumber:
		sw $t3, 0($t0)	# Stores int to replace inside array
		j replaceLoop
		
	printArrInt:
		addi $sp, $sp, -4	# Allocate for .word element
		sw $a0, 0($sp)		# Store word in stack. This would preserve the change of our $a0 variable in the main
		
		move $t0, $a0		# Array parameter value gets $t0
		move $t1, $a1		# length parameter value gets $t1
		lw $t3, index			# Local iterator variable
		
	printNumber:
		lw $a0, 0($t0)
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0, space		# space variable from .data section
		syscall
		
		addi $t0, $t0, 4
		addi $t3, $t3, 1
		
		bne $t3, $t1, printNumber
		
		li $v0, 4
		la $a0, line		# space variable from .data section
		syscall
		
		lw $a0, 0($sp)		# get word from stack that we saved previously
		addi $sp, $sp, 4	# update the stack
		jr $ra				# go to main function
