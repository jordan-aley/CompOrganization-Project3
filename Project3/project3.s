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
