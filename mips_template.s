######################
#                    #
# Project Submission #
#                    #
######################

# Partner1: (your name here), (Student ID here)
# Partner2: (your name here), (Student ID here)



.data 
array:	.word 5, 8, 9, 1, 3, 4, 2, 6
init:	.asciiz "The initial array is: "
final:	.asciiz "The sorted array is: "
comma:	.asciiz ", "
newline:.asciiz "\n"

.text
.globl main

########################
#        main          #
########################

main:	
	# Print the array
	la $a0,array
	la $a1,init
	li $a2,8
	jal printList

	# Quicksort
	la $a0,array
	li $a1,0
	li $a2,7
	jal quickSort

	# Print the sorted array
	la $a0,array
	la $a1,final
	li $a2,8
	jal printList


exit:	li $v0,10
	syscall


########################
#        swap          #
########################
swap:
	# a0: base address
	# a1: index 1
	# a2: index 2
	# Swap the elements at the given indices in the list

	### INSERT YOUR CODE HERE
	sll $t1,$a1,2  		#multiply a1 by 4
	sll $t2, $a2,2 		#multiply a2 by 4
	add $t1 $t1,$a0 	#access the value that is stored in a1
	add $t2, $t2,$a0	#access value in a2
	lw $t3,0($t1) 		#store value in t1 to t3
	lw $t4,0($t2)		#store value in t2 to t4
	sw $t4,0($t1)		#store value in t4 to t1
	sw $t3,0($t2)		#store value in t3 to t2
	# return to caller
	jr $ra
	
	
########################
#   medianOfThree      #
########################
medianOfThree:
	# a0: base address
	# a1: left
	# a2: right
	# Find the median of the first, last and the middle values of the given list
	# Make this the first element of the list by swapping

	### INSERT YOUR CODE HERE
	addiu $sp, $sp, -24 # Allocate space for return address
	sw $ra, 8($sp) # Push return address onto stack
	sw $fp,4($sp)#push fp onto stack
	sw $a1,12($sp)#push parameters onto stack
	sw $a2,16($sp)
	sw $a0,20($sp)
	addiu $fp,$sp,24#move the frame pointer
	#Opertation begins
	add $t0,$a1,$a2#a1+a2/2
	srl $t0,$t0,1#shift right arithmetic to sign extend the value
	addi $t7, $t0, 0# t7 contains the real mid value

	sll $t1, $a1,2 #multiply a1 by 4
	sll $t2, $a2,2 #multiply a2 by 4
	sll $t0,$t0,2 #multiply mid by4
	add $t1,$a0,$t1#address for x[lo]
	add $t2,$a0,$t2#address for x[hi]
	add $t0, $a0, $t0#address for x[mid]
	lw $t3,0($t1)#access value of x[lo]
	lw $t4,0($t2)#access value of x[hi]
	lw $t5,0($t0)#access value of x[mid]
	

	#comparison begins
	slt $t8, $t4,$t3#if x[hi]<x[lo]
	bne $t8,$zero, case1Med	#go to case 1 
	j case2Med# if the statement is false go to the next condition
case1Med:  
	addi $a1, $a1,0#set a1 to lo
	addi $a2, $a2,0#set a2 to hi
	jal swap
	lw $a0, 20($sp)#restore the parameters
	lw $a1, 12($sp)
	lw $a2, 16($sp)


case2Med:  
	#third step
	slt $t8, $t4,$t5#see if x[hi]<x[mid]
	beq $t8,$zero, case3Med	#if not go to step 4
	addi $a1, $t7,0#set parameter to be mid
	addi $a2, $a2,0#set parametere as hi
	jal swap
	lw $a0, 20($sp)#restore parameters
	lw $a1, 12($sp)
	lw $a2, 16($sp)

	#fouth step

case3Med:  
	slt $t8, $t5,$t3#if x[mid]<x[lo]
	beq $t8,$zero, case4Med#if not go to the last step
	addi $a1, $a1,0#set parameter to lo
	addi $a2, $t7,0#set paramteer to mid
	jal swap
	lw $a0, 20($sp)#restore parameter
	lw $a1, 12($sp)
	lw $a2, 16($sp)

case4Med:	
	#last step
 	addi $a1, $a1,0#set parameter as lo
	addi $a2, $t7,0#set parametere as mid
	jal swap	
	lw $a0, 20($sp)#restore parameters
	lw $a1, 12($sp)
	lw $a2, 16($sp)

	lw $ra, 8($sp) # Push return address onto stack
	lw $fp,4($sp)
	lw $a1,12($sp)
	lw $a2,16($sp)
	lw $a0,20($sp)
	addiu $sp, $sp, 24 #clear up stack and return everything in position for caller
	# return to caller	
   jr $ra

########################
#      partition       #
########################
partition: 
	# a0: base address
	# a1: left  = first index to be partitioned
	# a2: right = last index to be partitioned
	# a3: pivot value
	# Return:
	# v0: The final index for the pivot element
	# Separate the list into two sections based on the pivot value

	### INSERT YOUR CODE HERE
	addiu $sp, $sp, -28 # Allocate space for return address
	sw $ra, 8($sp) # Push return address onto stack
	sw $fp,4($sp)#push framepointer to stack
	sw $a0,12($sp)#push parameter to stack
	sw $a1,16($sp)
	sw $a2,20($sp)
	sw $a3,24($sp)
	addiu $fp,$sp,28#move frame pointer to previous stack pointer
	
	slt $t0, $a1, $a2#compare left and right
	beq $t0,$zero, case1Part#if left >= right go to case 1
	sll $t1, $a1,2#a1*4
	add $t1, $a0, $t1#address for a1
	lw $t2, 0($t1)#load x[left] to t2
	slt $t0, $a3, $t2#compare x[left] and pivot
	bne $t0, $zero, case2Part#if this is true go to step 2
	j else#if non of the above go to else
case1Part:  
	addi $v0, $a1,0#return left
	j exitPart
case2Part:	
	addi $a2,$a2,-1#right=right-1
	jal swap #swap(x,left,right-1)
	lw $a2, 20($sp)
	addi $a2,$a2,-1#right =right-1
	jal partition #partition(x,left,right,pivot)
	j exitPart
else:	
	lw $a1,16($sp)
	lw $a2, 20($sp)
	addi $a1, $a1,1 #left=left+1
	jal partition#partition(x,left+1,right, pivot)
	lw $a1, 16($sp)#clear a1

exitPart:	lw $ra, 8($sp) # Push return address onto stack
	lw $fp,4($sp)#push framepointer back
	lw $a0,12($sp)#Push parameters back
	lw $a1,16($sp)
	lw $a2,20($sp)
	lw $a3,24($sp)
	addiu $sp, $sp, 28#reconstruct stack pointer
	# r eturn to caller
	jr $ra


########################
#      quickSort       #
########################
quickSort:
	# a0: base address
	# a1: left  = first index to be sorted
	# a2: right = last index to be sorted
	# Sort the list using recursive quick sort using the above functions

	### INSERT YOUR CODE HERE
	addiu $sp, $sp, -44 # Allocate space for return address
	sw $ra, 8($sp) # Push return address onto stack
	sw $fp,4($sp)#Push framepointer to stack
	sw $a0,12($sp)#parameters a0-a2 on stack
	sw $a1,16($sp)
	sw $a2,20($sp)
	sw $s0,24($sp)#push temporary values on stack
	sw $s1,28($sp)
	sw $s2,32($sp)
	sw $s3,36($sp)
	sw $s4,40($sp)
	addiu $fp,$sp,44#move framepointer
	
	addi $s2, $zero,1#temp register with value of 2 because two elements mean a difference of 1
	sub $s3, $a2, $a1# check the difference between the two indexes
	slt $s4, $s3,$s2#if it is less than 1
	bne $s4,$zero,exitQuick #exit the program because $t4 would be 0
	

	jal medianOfThree#step 2 
	
	lw $a1,16($sp)
	sll $s0, $a1,2
	add $s0,$a0,$s0
	lw $s1,0($s0)# load out the element in the first index	
	addi $a3, $s1,0#change pivot to x[first]

	addi $a1,$a1,1#first+1
	lw $a2, 20($sp)
	jal partition#partition(x,first+1,last, pivot)
	addi $s3,$v0,-1# store the return value from partition to t3 and -1
	sw $s3,36($sp)

	addi $a2, $s3,0 

	addi $a1,$a1,-1
	jal swap#swap(x,first,index)
	
	lw $a1,16($sp)
	lw $s3,36($sp)
	addi $a2,$s3,-1 #index=index-1
	jal quickSort#quickSort(x,first,index-1)
	#last step
	lw $s3,36($sp)

	addi $a1, $s3,1#a1= index+1
	lw $a2,20($sp)
	jal quickSort#
exitQuick:
	lw $ra, 8($sp) # Push return address onto stack
	lw $fp,4($sp)
	lw $a0,12($sp)
	lw $a1,16($sp)
	lw $a2,20($sp)
	lw $s0,24($sp)
	lw $s1,28($sp)
	lw $s2,32($sp)
	lw $s3,36($sp)
	lw $s4,40($sp)
	addiu $sp,$sp,44


	# return to caller
	jr $ra

########################
#      printList       #
########################
printList:	
	# a0: base address
	# a1: message to be printed
	# a2: length of the array
	add $t0,$a0,$0
	add $t1,$a2,$0

	li $v0,4
	add $a0,$a1,$0
	syscall			#Print message
	
	
next:
	lw $a0,0($t0)
	li $v0,1
	syscall			#Print int

	addi $t1,$t1,-1
	bgt $t1,$0,pnext	
	li $v0,4		# if end of list
	la $a0,newline		# Print newline
	syscall
	jr $ra
pnext:	addi $t0,$t0,4
	li $v0,4
	la $a0,comma
	syscall			# Print comma
	j next
