.data
	data: .space 1001
	output: .asciiz "\n"
	not_valid: .asciiz "NaN"
	comma: .asciiz ","

main:
	#reads user input
	li $v0,8	
	la $a0,data	 
	li $a1, 1001	
	syscall
	jal Subprog1

jump:
	#jumps to the print function
	j print 

Subprog1:
	#checks the input
	sub $sp, $sp,4 
	sw $a0, 0($sp)
	lw $t0, 0($sp) 
	addi $sp,$sp,4 
	move $t6, $t0 
