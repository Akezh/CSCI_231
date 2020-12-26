.data
	DISPLAY: .space 65536
	DISPLAYWIDTH: .word 128
	DISPLAYHEIGHT: .word 128
	red: .word 0xff0000
	green: .word 0x00ff00
	test_a_num: .float 30.0
	test_b_num: .float 50.0
	
	one_float: .float 1.0
	zero_float: .float 0.0

.text
main:
	li $a0, 64		
	li $a1, 64
	lw $a2, green
	lwc1 $f12, test_a_num
	lwc1 $f14, test_b_num	# parameters are above
	
	lwc1 $f0, zero_float 	# constant for zero float
	lwc1 $f1, one_float 	# constant for one float
	
	jal drawEllipse			# call function with a = 30, b = 50
	
	li $a0, 64
	li $a1, 64
	lw $a2, red
	lwc1 $f12, test_b_num
	lwc1 $f14, test_a_num
	
	jal drawEllipse			# call function with a = 50, b = 30
	
	li $v0, 10			# Finish program
	syscall
		
		
		
drawEllipse:
	addi $sp, $sp, -4		
	sw $ra, -4($sp)			# Save the address to return to the right place at the end
	
	move $s0, $a0			# Assign function parameters
	move $s5, $a1			# Assign function parameters
	li $t3, 0
	li $t4, 128
	loop:
		mtc1 $t3, $f13			# t3 - int x
		cvt.s.w $f11, $f13		# f11 - float x
		mtc1 $s0, $f6			# s0 - int 64
		cvt.s.w $f5, $f6		# f5 - float 64
		
		# sqrt(1 - ((x-64)^2 / a^2)) * b + 64
		sub.s $f11, $f11, $f5
		mul.s $f11, $f11, $f11
		div.s $f11, $f11, $f12
 		div.s $f11, $f11, $f12
		sub.s $f11, $f1, $f11
		c.lt.s 1 $f11, $f0
		bc1t 1, sqrt_neg_handler 		# check if less than 0 then update loop
 		sqrt.s $f11, $f11
 		mul.s $f11, $f11, $f14			# x = x*b
 		add.s $f11, $f11, $f5			# x = x+64
 		
 		cvt.w.s $f9, $f11			# convert .float x to .word
 		mfc1 $s2, $f9
 	
		add $a0, $t3, 0				# x - coordinate
		add $a1, $s2, 0				# y - coordinate
		jal set_pixel_color
		
		add $a0, $t3, 0				# x - coordinate
		li $t6, 128
		sub $t6, $t6, $s2			
		
		add $a1, $t6, 0				# newly obtained y-coordinate
		jal set_pixel_color
		
		addi $t3, $t3, 1
		bge $t3, $t4, exitProcedure
		j loop
	
	sqrt_neg_handler: 
		addi $t3, $t3, 1
		bge $t3, $t4, exitProcedure
		j loop
		
	exitProcedure:
		lw $ra, -4($sp)
		jr $ra


set_pixel_color:
# Assume a display of width DISPLAYWIDTH and height DISPLAYHEIGHT
# Pixels are numbered from 0,0 at the top left
# a0: x-coordinate
# a1: y-coordinate
# a2: color
# address of pixel = DISPLAY + (y*DISPLAYWIDTH + x)*4
#			y rows down and x pixels across
# write color (a2) at arrayposition
	lw $t0, DISPLAYWIDTH
	mul $t0, $t0, $a1 	# y*DISPLAYWIDTH
	add $t0,$t0, $a0 	# +x
	sll $t0, $t0, 2 	# *4
	la $t1, DISPLAY 	# get address of display: DISPLAY
	add $t1, $t1, $t0	# add the calculated address of the pixel
	sw $a2, ($t1) 		# write color to that pixel
	jr $ra 			# return

