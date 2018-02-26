# Lab 9 - template for array multiplication
# The C code:
# 
#    for (i=0; i<16; i++) {
#     for (j=0; j<16; j++) {
#         C[i][j] = A[i][j] + B[j][i];
#     }
#    } 
#
# Avoid using multiplication. I chose the bounds
# so that you can use shifts.

   	.text

main: 
   	addi   $sp, $sp, -4
	sw     $ra, 0($sp)     # save up $ra coz not leaf

   	# Initializing arrays A and B
   	addi   $t0, $zero, 0
   	addi   $t1, $zero, 256

 	la     $t3, A		# addr of A
 	la     $t4, B		# addr of B
L0:
     	sw     $t0, 0($t3)      # i -> A[i] - treating A as a 1-D array
     	sw     $t0, 0($t4)      # i -> B[i] - treating B as a 1-D array
        addi   $t0, $t0, 1
        addi   $t3, $t3, 4
        addi   $t4, $t4, 4
        bne    $t0, $t1, L0	# less than 256, loop

# FILL IN YOUR CODE HERE!!!
# All of the T registers can be used at this point.

		
	


# END OF STUDENT CODE - 
# make sure it is safe for following to use the T registers.

	# Now we compute a checksum to see if you done it correctly
   	addi   $t0, $zero, 0
   	addi   $t1, $zero, 256
   	addi   $t2, $zero, 0 	# checksum
 	la     $t3, C		# addr of C

L3:
	lw     $t4, 0($t3)	# C[i]
	add    $t2, $t2, $t4
        addi   $t0, $t0, 1
        addi   $t3, $t3, 4

	bne    $t0, $t1, L3

	# If checksum is not 65280, then you are wrong.
	li     $t5, 65280
	bne    $t2, $t5, WRONG

	la     $a0, Str1
 	addi   $v0, $zero, 4
     	syscall
   	j      DONE

WRONG:
	la     $a0, Str2
 	addi   $v0, $zero, 4
     	syscall

	addi   $a0, $t2, 0
 	addi   $v0, $zero, 1
     	syscall

	la     $a0, Str3
 	addi   $v0, $zero, 4
     	syscall
DONE:
	lw     $ra, 0($sp)
   	addi   $sp, $sp, 4
    	jr     $ra		# That's all folks!

   	.data 
A: 	.space 1024		# 1024 bytes for storing array A
B: 	.space 1024		# 1024 bytes for storing array B
C: 	.space 1024		# 1024 bytes for storing array C
Str1:	.asciiz "Your answer is correct!\n"
Str2:	.asciiz "Sorry, try again... your answer is wrong!\nYour computed result is "
Str3:	.asciiz " and not the expected 65280.\n"
