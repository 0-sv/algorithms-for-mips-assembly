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

la $t5, C
addi $t0, $zero, 0		# index i
addi $t1, $zero, 16		# end of outer loop

L1:
		addi $t2, $zero, 0		# index j

		L2:
				#do the addition operation here

				sll $t3, $t0, 4		# $t3 contains 16 * i
				add $t3, $t3, $t2	# $t3 contains (16 * i) + j
				sll $t3, $t3, 2		# $t3 contains 4((16 * i) + j)

				# $t3 is the offset for A and C

				sll $t4, $t2, 4		# $t4 contains 16 * j
				add $t4, $t4, $t0	# $t4 contains (16 * j) + i
				sll $t4, $t4, 2		# $t4 contains 4((16 * j) + i)

				# $t4 is the offset for B

				la $t7, A #t7 is the address of A
				add $t7, $t7, $t3 #adds offset t3 into t7; t7 now points to the specific cell
				lw $t5, 0($t7)	# $t5 contains the value of A[i][j]
				la $t8, B	# loads address of B 
				add $t8, $t8, $t4	# add offset t4 into t8
				lw $t6, 0($t8)	# $t6 contains the value of B[j][i]

				add $t5, $t5, $t6	# $t5 contains A[i][j] + B[j][i]

				la $t9, C	#t9 is address of C
				add $t9, $t9, $t3

				sw $t5, 0($t9)		# C contains $t5

				#end of addition operation	

				
				addi $t2, $t2, 1	# j++
				bne $t2, $t1, L2	# end of inner loop

		addi $t0, $t0, 1	# i++
		bne $t0, $t1, L1
		

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
