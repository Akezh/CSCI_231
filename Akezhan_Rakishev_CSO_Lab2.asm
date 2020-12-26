.data 
	Arr: .word 21 20 51 83 20 20
	length: .word 6
	x:	 .word 20
	y: 	 .word 5
	index: .word 0
	space: .asciiz " "

.text
	main:
		lw $t0, length
		lw $t1, x
		lw $t2, y
		lw $t3, index	# replacement iterator
		lw $t6, index	# printing iterator
		la $s0, Arr		# For replacement traversal
		la $s1, Arr		# For printing traversal
				
		while:
			beq $t3, $t0, printNumbers   # while t0 is not equal than t3
			
			lw $t4, 0($s0)				# load the e
			beq $t4, $t1, convertNum	# calling convertNum function is the value - x
			
			addi $s0, $s0, 4	# updating arr address to get next element of an array
			addi $t3, $t3, 1	# incrementing iterator by 1
			
			j while
						
		printNumbers:
			beq $t6, $t0, exit		# while t6 is not equal than t3
						
			lw $t4, 0($s1)
			
			li $v0, 1
			move $a0, $t4
			syscall
			
			li $v0, 4
			la $a0, space
			syscall
			
			addi $s1, $s1, 4
			addi $t6, $t6, 1
			
			j printNumbers
			
		exit: 
			li $v0, 10	# Finish program
			syscall

	convertNum:		# function that updates the array elements (Store Word)
		sw $t2, 0($s0)
		j while