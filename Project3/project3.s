.data
	data: .space 1001
	output: .asciiz "\n"
	not_valid: .asciiz "NaN"
	comma: .asciiz ","

.text
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
	ble $s0, 86, valid	
	ble $s0, 96, invalid_loop 
	ble $s0, 118, valid 	
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

next:
	#checks characters in substring
	bgt $t2,0,insub 
	bge $t3,5,insub 
	addi $t1,$t1,1  	
	sub $sp, $sp,4 
	sw $t6, 0($sp) 
	move $t6,$t0  
	lw $t4,0($sp) 
	li $s1,0  
	jal Subprog2
	lb $s0, ($t0) 
	beq $s0, 0, jump 
	beq $s0, 10, jump  
	beq $s0,44, invalid_loop 
	li $t2,0 
	j begin

Subprog2:
	#checks # of characters left convert
	beq $t3,0,done  
	addi $t3,$t3,-1 
	lb $s0, ($t4) 
	addi $t4,$t4,1	
	j Subprog3 

continue:
	#stores converted character
	sw $s1,0($sp)	
	j Subprog2

Subprog3:
	#stores # of characters left for exponent
	move $t8, $t3	
	li $t9, 1	
	ble $s0, 57, num
	ble $s0, 86, uppercase
	ble $s0, 118, lowercase

num:
	#converts bits to intergers
	sub $s0, $s0, 48	 
	beq $t3, 0, combine	
	li $t9, 32		
	j exponent

uppercase:
	#converts bits to uppercase
	sub $s0, $s0, 55 
	beq $t3, 0, combine 
	li $t9, 32
	j exponent

lowercase:
	#converts bits to lowercase
	sub $s0, $s0, 87 
	beq $t3, 0, combine 
	li $t9, 32
	j exponent

exponent:
	#raises base to desired exponent 
	ble $t8, 1, combine	
	mul $t9, $t9, 32 	
	addi $t8, $t8, -1	
	j exponent

combine:
	#add value together
	mul $s2, $t9, $s0	
	add $s1,$s1,$s2		 
	j continue

done: 
	#jump to substring
	jr $ra	

print:
	#prints out the values
	mul $t1,$t1,4 
	add $sp, $sp $t1 

finish:	
	#ends the program
	sub $t1, $t1,4	
	sub $sp,$sp,4 	
	lw $s7, 0($sp)	
	beq $s7,-1,invalid_print 
	li $v0, 1
	lw $a0, 0($sp) 
	syscall

remain:	
	#checks if any characters remaining
	beq $t1, 0,exit 
	li $v0, 4
	la $a0, comma 
	syscall
	j finish

invalid_print:
	#prints invalid input
	li $v0, 4
	la $a0, not_valid 
	syscall	
	j remain 

exit:
	li $v0, 10
	syscall