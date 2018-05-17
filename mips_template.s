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
	sll $t1,$a1,2  #multiply a1 by 4
	sll $t2, $a2,2 #multiply a2 by 4
	add $t1 $t1,$a0 #access the value that is stored in a1
	add $t2, $t2,$a0# access value in a2
	lw $t3,0($t1) #store value in t1 to t3
	lw $t4,0($t2)# store value in t2 to t4
	sw $t4,0($t1)#store value in t4 to t1
	sw $t3,0($t2)#store value in t3 to t2
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
	sw $fp,4($sp) #push frame pointer to stack
	sw $a1,12($sp) #push parameters to stack
	sw $a2,16($sp)
	sw $a0,20($sp)
	addiu $fp,$sp,24 # end caller's responsiblity 
	#Opertation begins
	sll $t1, $a1,2#multiply a1 by 4
	sll $t2, $a2,2 #multiply a2 by 4
	add $t1,$a0,$t1#get location for x[a1]
	add $t2,$a0,$t2#location for x[a2]
	add $t0,$a1,$a2#a1+a2/2
	sra $t0,$t0,1#shift right arithmetic to sign extend the value
	mflo $t0#round down 
	sll $t0,$t0,2#multiply mid by4
	add $t0, $a0, $t0#address for x[mid]
	lw $t3,0($t1)#access value of x[lo]
	lw $t4,0($t2)#access value of x[hi]
	lw $t5,0($t0)#access value of x[mid]
	slt $t6, $t4,$t3 #compare x[lo] and x[hi]
	bne $t6,$zero, case1 # if x[hi]< x[lo]
case1: 	add $a0, $a0,0
	add $a1, $a1,0
	add $a2, $a2,0
	jal swap
	j exit
	slt $t6, $t4,$t0
	bne $t6,$zero, case2
case2:  
	slt $t6
	
	# return to caller
	
exit:   jr $ra


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

	# return to caller
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
