.data
	Fib: .word 0, 1		# Init an array
	
.text
	li $t0, 0			# zero, as 2nd element for adding
	li $t1, 0 			# Fib[0] first number
	li $t2, 1			# Fib[1] second number
	add $t3, $t1, $t2
		
	la $t4, Fib			# Add the array address $t4
	li $t5, 4 			# We need to start from the second index in the array
	li $t7, 4 			# The coefficient at which the array cell is changing (.word worths 4 bytes)
	add $t5, $t5, $t7	# Add the coefficient
	add $t5, $t5, $t4	
	sw $t3, 0($t5)		# Put the value inside the array element (Fib[2])
	
	add $t1, $t2, $t0	
	add $t2, $t3, $t0
	add $t3, $t1, $t2	# Updating vars
	
	add $t5, $t5, $t7
	sw $t3, 0($t5)		# Filling the (Fib[3])
	
	add $t1, $t2, $t0	
	add $t2, $t3, $t0
	add $t3, $t1, $t2	# Updating vars
	
	add $t5, $t5, $t7
	sw $t3, 0($t5)		# Filling the (Fib[4])
	
	add $t1, $t2, $t0	
	add $t2, $t3, $t0
	add $t3, $t1, $t2	# Updating vars
	
	add $t5, $t5, $t7
	sw $t3, 0($t5)		# Filling the (Fib[5])
	
	add $t1, $t2, $t0	
	add $t2, $t3, $t0
	add $t3, $t1, $t2	# Updating vars
	
	add $t5, $t5, $t7
	sw $t3, 0($t5)		# Filling the (Fib[6])
