.data
	first: .asciiz "Enter the first num: "
	second:  .asciiz "Enter the second num: "
	sum: .asciiz "The sum is "
	
.kdata
	restart_msg: .asciiz "Try Again!\n"
	
.text
main:
	li $v0, 4
	la $a0, first
	syscall
	
	# First num input + Store
	li $v0, 5
	syscall
	
	move $s0, $v0
	
	li $v0, 4
	la $a0, second
	syscall
	
	# Second num input + Store
	li $v0, 5
	syscall
	move $s1, $v0
	
	add $s2, $s0, $s1	# Get sum in $s2
	
	li $v0, 4     # Print Sum
	la $a0, sum		
	syscall
	
	li $v0, 1		# Print answer
	la $a0, 0($s2)
	syscall
	
	li $v0, 10	  # Exit
	syscall
	
	
.ktext 0x80000180		# Exception handling address
	mfc0 $k0, $14		# Move from coproc0
	addi $k0, $zero, 0x00400000		# Address of the point at which the program starts
	addi $14, $k0, 0 
	mtc0 $k0, $14		# Move to coproc0
		
	li $v0, 4
	la $a0, restart_msg
	syscall
	
	eret
