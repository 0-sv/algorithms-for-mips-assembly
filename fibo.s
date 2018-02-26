# fibo
.data

fibostr1: .asciiz "The "
fibostr2:  .asciiz "th fibonacci number is: "
endl:	.asciiz "\n"

.text

.globl main

main:
	addi	$sp, $sp, -4	# Make space on stack.
	sw	$ra, 0($sp)	# Save return address.

	li $v0, 5		
	syscall
	move $s0, $v0	# read integer from input

	li	$v0, 4
	la	$a0, fibostr1
	syscall			# Display first sentence.

	li	$v0, 1
	move $a0, $s0
	syscall			# Print input integer.

		jal     FiboRecursive          # call fibo, result in $v0
		move    $s0, $v0        # save result
		
	li	$v0, 4
	la $a0, fibostr2
	syscall			# Display second sentence.

	li	$v0, 1
	move $a0, $s0
	syscall			# Print integer result.

	la	$a0, endl
	li	$v0, 4
	syscall			# Print endl.

	li	$v0, 0		# Return zero.
	lw	$ra, 0($sp)	# Restore return address.
	addi	$sp, $sp, 4	# Restore stack pointer.

	jr	$ra

	
FiboRecursive: 
# This function calculates fibonacci 
		addi $sp, $sp, -12	# Make room for the stack so we can push the return address and n-1 and n-2. 
		sw   $ra, 0($sp)	# return address
		sw   $s0, 4($sp)	# first saved temporary	
		sw   $s1, 8($sp)	# second saved temporary

		add $s0, $a0, $zero		# Save argument value in saved temporaries register

		li $t1, 1		# Use reg $t1 to compare such that n == 0 || n == 1. Return to the caller if the latter is true.
		li $t3, 2		# Use reg $t2 to subtract from n
		beq  $s0, 0, Save0	# actual comparison n == 0
		beq  $s0, $t1, Save1	# actual comparison n == 1

		sub $a0, $s0, $t1		# n - 1
		jal FiboRecursive	# recursive call 

		add $s1, $zero, $v0		# Save $v0

		
		sub $a0, $s0, $t3	# n - 2

		jal FiboRecursive                     # recursive call

		add $v0, $v0, $s1           # add both return values

	Exit:
		lw $ra, 0($sp)		# retrieve stack values
		lw $s0, 4($sp)
		lw $s1, 8($sp) 
		addi $sp, $sp, 12

		jr $ra	# return to the caller

	Save0:
		li $v0,0	# if n == 0
		j Exit

	Save1: 
		li $v0, 1	# if n == 1
		j Exit

