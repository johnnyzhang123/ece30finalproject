######################
#                    #
# Project Submission #
#                    #
######################

# Partner1: (your name here), (Student ID here)
# Partner2: (your name here), (Student ID here)



.data 
array:	.word 5, 8, 1, 9, 3, 4, 2, 6

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
	sll $s1, $a1, 2  	#multiply index 1 by 4
	sll $s2, $a2, 2 	#multiply index 2 by 4
	add $s1, $s1, $a0 	#access the value that is stored in a1
	add $s2, $s2, $a0	#access value in a2
	lw $t3, 0($s1) 		#store value in t1 to t3
	lw $t4, 0($s2)		#store value in t2 to t4
	sw $t4, 0($s1)		#store value in t4 to t1
	sw $t3, 0($s2)		#store value in t3 to t2
	# return to caller
	jr $ra
	##############################
	#SWAP TEST SUCCESSFUL
	#########################
	
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
	sw $ra, 20($sp) 	#Push return address onto stack
	sw $fp, 16($sp)
	sw $s1, 12($sp)
	sw $s2,  8($sp)
	sw $s0,  4($sp)		
	addiu $fp, $sp, 24
	
	#Opertation begins
	sll $s1, $a1, 2		#Multiply a1 by 4
	sll $s2, $a2, 2		#Multiply a2 by 4
	move $s0, $a0		#Base address stored in $s0
	add $s1, $s0, $s1	#Get address for x[a1]=x[lo]
	add $s2, $s0, $s2	#Get address for x[a2]=x[hi]
	lw $t1, 0($s1)		#Get element of lo
	lw $t2, 0($s2)		#Get element of hi
	
	#Get address for x[mid] 
	add $t0, $t1, $t2	#(lo element + hi element)
	srl $t0, $t0, 1		#shift right arithmetic to sign extend the value
	mflo $t0		#round down 
	
	slt $t3, $t1, $t2	#compare x[lo] with x[hi]
	bne $t7, $zero, case1Med	
	
case1Med:  
	addi $a1, $t1,0
	addi $a2, $t2,0
	jal swap
	lw $a1, 12($sp)
	lw $a2,  8($sp)
	lw $a0,  4($sp)		
	slt $t3, $t2, $t0	#compare x[hi] with x[mid]
	bne $t3 ,$zero, case2Med	
case2Med:  
	addi $a1, $t0,0
	addi $a2, $t2,0
	jal swap
	lw $a1, 12($sp)
	lw $a2,  8($sp)
	lw $a0,  4($sp)
	slt $t3, $t0, $t1	#compare x[mid] with x[lo]
	bne $t3, $zero, case3Med
case3Med:  
	addi $a1, $t1,0
	addi $a2, $t0,0
	jal swap
	lw $a1, 12($sp)
	lw $a2,  8($sp)
	lw $a0,  4($sp)
	
 	addi $a1, $t1, 0
	addi $a2, $t0, 0
	jal swap

	lw $ra, 20($sp) 	
	lw $fp, 16($sp)
	lw $a1, 12($sp)
	lw $a2,  8($sp)
	lw $a0,  4($sp)		
	addiu $fp, $sp, 24
	
	# return to caller	
   	jr $ra
   ##############################################
   #MEDIAN OF THREE TEST FAILED
   ##################################################

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
	sw $ra, 4($sp) # Push return address onto stack
	sw $fp,8($sp)
	sw $a0,12($sp)
	sw $a1,16($sp)
	sw $a2,20($sp)
	sw $a3,24($sp)
	addiu $fp,$sp,28
	
	sll $t1, $a1,2
	add $t1, $a0, $t1
	lw $t2, 0($t1)
	slt $t0, $a1, $a2#compare left and right
	beq $t0,$zero, case1Part
	slt $t0, $a3, $t2#compare x[left] and pivot
	bne $t0, $zero, case2Part
	j else
case1Part:  
	addi $v0, $a1,0
	j exitPart
case2Part:	
	addi $a2,$a2,-1
	jal swap 
	jal partition 
	lw $a2, 20($sp)
	j exitPart
else:	addi $a1, $a1,1 
	jal partition
	lw $a1, 16($sp)

exitPart:	lw $ra, 4($sp) # Push return address onto stack
	lw $fp,8($sp)
	lw $a0,12($sp)
	lw $a1,16($sp)
	lw $a2,20($sp)
	lw $a3,24($sp)
	addiu $sp, $sp, 28
	# r eturn to caller
	jr $ra
	########################################
	#YET TO TEST
	#########################################

########################
#      quickSort       #
########################
quickSort:
	# a0: base address
	# a1: left  = first index to be sorted
	# a2: right = last index to be sorted
	# Sort the list using recursive quick sort using the above functions

	### INSERT YOUR CODE HERE
	addiu $sp, $sp, -24 # Allocate space for return address
	sw $ra, 8($sp) # Push return address onto stack
	sw $fp,4($sp)
	sw $a0,12($sp)
	sw $a1,16($sp)
	sw $a2,20($sp)
	addiu $fp,$sp,24
	
	sll $t0, $a1,2
	add $t0,$a0,$t0
	lw $t1,0($t0)

	addi $t2, $zero,2
	sub $t3, $a2, $a1
	slt $t4, $t2,$t3
	beq $t4,$zero,exitQuick
	
	jal medianOfThree
	
	addi $a3, $t1,0

	addi $a1,$a1,1#first+1
	jal partition#partition(x,first+1,last, pivot)
	addi $a2, $v0,-1  #index= previous result -1 
	lw $a1,16($sp)#restore first
	jal swap#swap(x,first,index)
	
	addi $a2,$a2,-1 #index=index-1
	jal quickSort#quickSort(x,first,index-1)
	addi $a2,$a2,1#index-1+1
	
	addi $a1,$a2,1# change first to index+1
	lw $a2, 20($sp)#change from index to last
	jal quickSort#quickSort(x,index+1,last)

exitQuick:	lw $ra, 8($sp) # Push return address onto stack
	lw $fp,4($sp)
	lw $a0,12($sp)
	lw $a1,16($sp)
	lw $a2,20($sp)
	addiu $sp,$sp,24


	# return to caller
	jr $ra

	##########################################################
	#QUICK SORT TEST FAILED
	###########################################################

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

