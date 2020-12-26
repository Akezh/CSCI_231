.data
array: .space 1024

.text
main:
	la $t1, array		# Loading array address to $t1
	li $t0, 1			# lower bound
	li $t2, 1024		# upper bound
	li $t3, 1
	
	updateArray:
		sb $t3, 0($t1)
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		ble $t0, $t2, updateArray
		li $v0, 10	# Finish program
		syscall
		
#Number of blocks: 4
#Cache block size: 8
#YOUR METRIC SCORE: 4986
#The reasons for my optimization
#In Assembly code: Storing each byte in the array by sb (store byte)
#In the configurations of cache parameters: Larger cache block size results in the higher performance