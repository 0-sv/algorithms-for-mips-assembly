# strlen(s) skeleton

.text

.globl main

main:
	addi	$sp, $sp, -4	# Make space on stack.
	sw	$ra, 0($sp)	# Save return address.

        la      $a0, mystr      # load address of mystr into first argument
        jal     strlen          # call strlen, result in $v0
        move    $s0, $v0        # save up result
		
		jal		fibo

	la	$a0, dispstr
	li	$v0, 4
	syscall			# Display dispstr.

	move	$a0, $s0
	li	$v0, 1
	syscall			# Print integer result.

	la	$a0, endl
	li	$v0, 4
	syscall			# Print endl.

	li	$v0, 0		# Return zero.
	lw	$ra, 0($sp)	# Restore return address.
	addi	$sp, $sp, 4	# Restore stack pointer.

	jr	$ra

	
strlen:
# This is the function that you are to write.
	addi $t1, $t1, 0
	Loop: 
		lb $t0, 0($a0)	# load char into t0.
		beq $t0, 0, Exit	# if there's still a character..
		addi $a0, $a0, 1	# increase address value of $a0
		addi $t1, $t1, 1
		j Loop				# go back 

	Exit:
		move $v0, $t1	# load count into $v0 
		jr	$ra		# Return.


.data

dispstr: .asciiz "The length of mystr is "
mystr:  .asciiz "This is the string whose length I want to obtain"
endl:	.asciiz "\n"
