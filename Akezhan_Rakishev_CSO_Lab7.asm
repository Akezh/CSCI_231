.data
	user_inp: .asciiz "Enter the number to defince cos(x): "
	limit: .word 6
	new_line: .asciiz "\n"
	zero_float: .float 0.0
	one_float: .float 1.0
	pi: .float 3.1415927
	pi_deg: .float 180.0
	
.text
main:
	lw $t0, limit	# t0 would play the role of limit (run loop max 6 times)
	lwc1 $f4, zero_float
	lwc1 $f5, one_float
	lwc1 $f6, pi
	lwc1 $f7, pi_deg
	li $t1, 1		# t1 would be an iterator
	li $t2, -1
	
	# 4 must return 1 + 16 + 64 + 256 + 
	
	loop: 
		li $v0, 4			# Print String
		la $a0, user_inp
		syscall
		
		li $v0, 5		# Read input
		syscall
		
		move $t3, $v0		
		beq $t3, $t2, exit	# if $v0 - input is -1 then exit
		
	convert_to_radians:
		mtc1 $t3, $f12
 		cvt.s.w $f12, $f12
		mul.s $f8, $f12, $f6
		div.s $f8, $f8, $f7		# X - value in radians is kept in $f8	
			
		add.s $f9, $f5, $f4		# The answer for the equation if kept in $f9
 		li $s3, 2			# Current Power, since we would consider the 2nd element of sequence
		li $t8, 1			# holds current step's temporary value	
		
		li $s5, 1			# Always 1
		li $t7, 0			# holds current step's sign (0 - subtract, 1 - plus)
		
		cosine_loop:
			move $a0, $s3	# a0 keeps int number (for power and factorial)
			add.s $f12, $f4, $f8	# $f12 is an argument for power function
			
			jal power
			mtc1 $v0, $f17	# Take the value of a function $f17 is a final val of every iteration
			
			jal factorial
			move $t9, $v0
			mtc1 $t9, $f13
 			cvt.s.w $f13, $f13
 			div.s $f17, $f17, $f13
			
			beq $t7, $zero, substraction
			beq $t7, $s5, addition
		
		update_iterators:		
			addi $s3, $s3, 2
			addi $t1, $t1, 1
			ble $t1, $t0, cosine_loop
			
			
		li $v0, 2
		mov.s $f12, $f9		# Output the answer
		syscall
		
		li $v0, 4
		la $a0, new_line
		syscall
		
		addi $k0, $zero, 0x00400000		# Address of the point at which the program starts
		j main
		
	substraction:
		addi $t7, $t7, 1
		sub.s $f9, $f9, $f17
		
		j update_iterators
		
	addition:
		subi $t7, $t7, 1
		add.s $f9, $f9, $f17
		
		j update_iterators
		
	power:
		add.s $f10, $f12, $f4
		move $t4, $a0	# power
		add.s $f16, $f10, $f4
		li $t5, 2	# iterator
					
		power_loop:
			addi $t5, $t5, 1
			mul.s $f10, $f10, $f16
			ble $t5, $t4, power_loop
		
		mfc1 $v0, $f10
		
	jr $ra
	
		
	factorial:
		subi $sp, $sp, 8	# keep the data of an answer
		sw $ra, 4($sp)		# keep the answer
		sw $s0, 0($sp)		# s0 saves the contents of $a0
		beq $a0, $zero, quit_factorial	# if $a0 reached zero, then quit the function
	
		perform_operation:
		addi $v0, $zero, 1
		move $s0, $a0
		subi $a0, $a0, 1	# Decrement a0 to get next multiplier factor
		jal factorial
		mult $s0, $v0
		mflo $v0			# Get the lo value of multiplication
	
		quit_factorial:
		lw $ra, 4($sp)		# get the initial address of when we went to factorial function
		lw $s0, 0($sp)		
		addi $sp, $sp, 8	
		jr $ra
	
	exit:
		li $v0, 10
		syscall