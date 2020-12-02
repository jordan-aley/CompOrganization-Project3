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

begin:
	#check for spaces or tabs at the start and within the input
	li $t2,0 
	li $t7, -1 
	lb $s0, ($t0) 
	beq $s0, 0, insub 
	beq $s0, 10, insub
	beq $s0, 44, invalid_loop 
	beq $s0, 9, pass  
	beq $s0, 32, pass 
	move $t6, $t0 
	j loop 

pass:
	#skips the spaces in the string
	addi $t0,$t0,1 
	j begin 

loop:
	#iterates through each character 
	lb $s0, ($t0) 
	beq $s0, 0, next
	beq $s0, 10, next  	
	addi $t0,$t0,1 	
	beq $s0, 44, substring 

check_char:
	#looks at each character
	bgt $t2,0,invalid_loop 
	beq $s0, 9,  pass 
	beq $s0, 32, pass 
	ble $s0, 47, invalid_loop 
	ble $s0, 57, valid
	ble $s0, 64, invalid_loop 
	ble $s0, 85, valid	
	ble $s0, 96, invalid_loop 
	ble $s0, 117, valid 	
	bge $s0, 118, invalid_loop 

space:
	#keeps track of spaces/tabs
	addi $t2,$t2,-1 
	j loop

valid:
	#keeps track of characters in substring
	addi $t3, $t3,1 
	mul $t2,$t2,$t7 
	j loop

invalid_loop:
	#keeps track invalid characters in substring
	lb $s0, ($t0) 
	beq $s0, 0, insub
	beq $s0, 10, insub  	
	addi $t0,$t0,1 	
	beq $s0, 44, insub 
	j invalid_loop 

insub:
	#keeps track of # of characters in substring 
	addi $t1,$t1,1 	
	sub $sp, $sp,4
	sw $t7, 0($sp) 
	move $t6,$t0  
	lb $s0, ($t0) 
	beq $s0, 0, jump
	beq $s0, 10, jump 
	beq $s0,44, invalid_loop 
	li $t3,0 
	li $t2,0 
	j begin

substring:
	#checks if space before valid character in substring
	mul $t2,$t2,$t7 