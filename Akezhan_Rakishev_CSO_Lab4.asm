# void reverse(char String[], int length) {
#   char strCopy[length];
#   int i;
#   int j = 0;
#
#   // saveStringToStack method
#   for (i = length-1; i >= 0; i--) {
#     strCopy[j] = String[i];
#     j++;
#   }
#
#   // reverse method
#   for (i = 0; i < length; i++) {
#     String[i] = strCopy[i];
#   }
# }

.data
	S: .asciiz "Hello"
	length: .word 5
	
.text 
	main:
		la $a0, S
		lw $a1, length
	
		jal reverse			# Call reverse
		jal printString		# Call print string method
		
		li $v0, 10
		syscall
	
	reverse:
		subu $sp,$sp,$a1	# Allocate memory in a stack

		move $t0, $a0		# String address
		move $t1, $a1		# Length
		
		li $t5, 0			# Iterator i for saveStringToStackFunction
		li $t2, 0			# Iterator i for reverseLoop
		addi $t6, $t0, 0	# Copy of address to string
	
	saveStringToStack:		# Helper function that saves all character in a Stack Pointer
		lb $t3, 0($t6)		# Load character from string
		sb $t3, 0($sp)		# Store character in stack pointer
		
		beq $t5, $t1, reverseLoop	# When iterator reach string length then go to reverse loop
		addi $t5, $t5, 1			
		
		addi $t6, $t6, 1		# Update address
		addi $sp, $sp, 1		# Update Stack Pointer
		
		j saveStringToStack
		
	reverseLoop:
		subi $sp, $sp, 1		# Decrement the stack pointer to obtain the copied values
		
		lb $t3, 0($sp)			# Load character from Stack Pointer
		sb $t3, 0($t0)			# Store (Update) character to String
		
		addi $t0, $t0, 1
		
		beq $t2, $t1, endLoop
		addi $t2, $t2, 1
		
		j reverseLoop
				
	endLoop:
		jr $ra
		
	
	printString:
		li $v0, 4    # print_string    
 		la $a0, S
 		syscall
 		
 		jr $ra
