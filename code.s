.data
	space : .asciiz " "
	chline : .asciiz "\n"

.text
.globl main
main: #main function that receives input that contains start point, number of vertex, edge, and edge points whose number is different by number of edge value, and run dfs and bfs function
 	li $v0, 5
	syscall
	move $s0, $v0 #receive number of vertex

 	li $v0, 5
	syscall
	move $s1, $v0 #receive number of edge

	li $v0, 5
	syscall
	move $s2, $v0 #receive start vertex

	sll $t1, $s1, 3
	negu $t1, $t1
	add $sp, $sp, $t1
	addi $s3, $sp, 0
	add $sp, $sp, $t1
	addi $s4, $sp, 0 #edge information is stored in stack and the pointers are in s registers

	addi $t0, $s0, 1
	sll $t0, $t0, 2
	negu $t0, $t0
	add $sp, $sp, $t0
	addi $s5, $sp, 0
	add $sp, $sp, $t0
	addi $s6, $sp, 0 #ministack information stored in stack with which dfs and bfs determine what vertexs they visited, and the pointers are stored in s register

	
	
	addi $sp, $sp, -8
	addi $s7, $sp, 0 
	
	sw $s0, 0($s7)
	sw $s1, 4($s7) #informations stored in stack that have number of vertexs, edges. A kind of static value. the pointer are stored in s register

	addi $t0, $zero, 0
	addi $t1, $s0, 0
	addi $t4, $zero, 0
	jal loop1 #initial ministack
	
	addi $t1, $s0, 0
	sw $t1, 0($s5)
	sw $t4, 0($s6) #dfs: first element is number of vertex, bfs: zero

	addi $t0, $zero, 0
	add $t1, $s1, $s1
	jal loop2 #initial edges

	addi $a0, $s7, 0
	addi $a1, $s2, 0
	addi $a2, $s3, 0
	addi $a3, $s5, 0

	addi $sp, $sp, -16
	sw $s7, 12($sp)
	sw $s2, 8($sp)
	sw $s4, 4($sp)
	sw $s6, 0($sp) #store registers that need for next bfs in stack
	jal dfs #dfs with 4 arguments

	lw $s7, 12($sp)
	lw $s2, 8($sp)
	lw $s4, 4($sp)
	lw $s6, 0($sp)
	addi $sp, $sp, 16

	addi $a0, $s7, 0
	addi $a1, $s2, 0
	addi $a2, $s4, 0
	addi $a3, $s6, 0
	jal bfs #bfs with 4 arguments


	
	li $v0, 10
	syscall #termination of main
	
	jr $ra

	
loop1: #loop that makes initial case of ministack
	slt $t2, $t0, $t1
	beq $t2, $zero, exit1
	addi $t0, $t0, 1
	sll $t2, $t0, 2
	add $t3, $t2, $s5
	sw $t4, 0($t3)
	add $t3, $t2, $s6
	sw $t4, 0($t3)
	j loop1

exit1: #exit point of loop1
	jr $ra

loop2: #store edge points in a array
	slt $t2, $t0, $t1
	beq $t2, $zero, exit2
	
	sll $t2, $t0, 2
	add $t3, $t2, $s3
	add $t4, $t2, $s4

	li $v0, 5
	syscall
	sw $v0, 0($t3)
	sw $v0, 0($t4)

	addi $t0, $t0, 1
	j loop2

exit2: #exit point of loop2
	jr $ra

lastzero: #funtion that returns the index of last zero of array
	addi $t0, $zero, 0
	addi $t1, $a1, 0
	j lastzeroloop
lastzeroloop: #if ith target value detected, return i
	slt $t2, $t0, $t1
	beq $t2, $zero, exitlz

	sll $t2, $t0, 2
	add $t3, $a0, $t2
	lw $t4, 0($t3)
	beq $t4, $zero exitlz
	addi $t0, $t0, 1
	j lastzeroloop

exitlz: #exit of lastzero
	addi $v0, $t0, 0
	jr $ra
	

allzero: #check whether all elements of array is zero
	addi $t0, $zero, 0
	addi $t1, $a1, 0
	j allzeroloop
allzeroloop:
	slt $t2, $t0, $t1
	beq $t2, $zero, exitaz1

	sll $t2, $t0, 2
	add $t3, $a0, $t2
	lw $t4, 0($t3)
	bne $t4, $zero exitaz0
	addi $t0, $t0, 1
	j allzeroloop

exitaz0: #exit of allzero when allzero is false
	addi $v0, $zero, 0
	jr $ra

exitaz1: #exit of allzero when allzero is true
	addi $v0, $zero, 1
	jr $ra

search: #funtion that search target value in array
	addi $t0, $zero, 0
	addi $t1, $a2, 0
	j searchloop
searchloop:
	slt $t2, $t0, $t1
	beq $t2, $zero, exitsh0

	sll $t2, $t0, 2
	add $t3, $a0, $t2
	lw $t4, 0($t3)
	beq $t4, $a1 exitsh1
	addi $t0, $t0, 1
	j searchloop

exitsh0: #case when target value is not in array
	addi $v0, $zero, -1
	jr $ra

exitsh1: #case when target value is in array that return index
	addi $v0, $t0, 0
	jr $ra


stacksearch: #search in stack diffent from search in that ignore first element that contains ministack pointer
	addi $t0, $zero, 0
	addi $t1, $a2, 0
	j stsearchloop
stsearchloop:
	slt $t2, $t0, $t1
	beq $t2, $zero, exitstsh0

	addi $t0, $t0, 1
	sll $t2, $t0, 2
	add $t3, $a0, $t2
	lw $t4, 0($t3)
	beq $t4, $a1 exitstsh1
	
	j stsearchloop

exitstsh0: #exit stacksearch case when target is not in stack
	addi $v0, $zero, -1
	jr $ra

exitstsh1: #exit stacksearch case when target is in stack
	addi $v0, $t0, 0
	jr $ra

stackingall: #funtion that used in bfs. find all edges from target vertex. if destination is in stack, the destination is already reserved, so the edge is deleted. If not in stack, compare to find minimal destination and store result in stack and recursively run stacking all until there is no destination from target vertex

	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)

	lw $t0, 4($a2)
	sll $t0, $t0, 1
	addi $a2, $t0, 0
	jal search

	lw $ra, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16

	addi $t0, $zero, -1
	beq $v0, $t0, exitsa2 #if no edge from target vertex, end stackingall

	addi $s0, $zero, 0
	lw $t2, 4($a2)
	add $s1, $t2, $t2 #number of iteration to look up all edges
	add $s2, $t2, $t2 #first result with a big value because we find minimal value
	addi $s3, $zero, -1 #initial index of minimal value
	j saloop

saloop:
	slt $t3, $s0, $s1
	beq $t3, $zero, exitsa1

	sll $t3, $s0, 2
	add $t3, $t3, $a0
	lw $t3, 0($t3)
	beq $t3, $a1, iseven #go to iseven when target vertex is detected
	addi $s0, 1
	j saloop

iseven: #because edge informations are in pair, contrast value is determined whether index is even or not
	andi $t4, $s0, 1
	beq $t4, $zero, evencase
	j oddcase

evencase: #if index is even
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)

	addi $t0, $a3, 0
	addi $t1, $s0, 1
	sll $t1, $t1, 2
	add $t1, $t1, $a0
	lw $t1, 0($t1)
	lw $t2, 0($a2)
	

	addi $a0, $t0, 0
	addi $a1, $t1, 0
	addi $a2, $t2, 0 #because arguments will be used later, they are stored in stack

	jal stacksearch #find the destination in stack

	lw $ra, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16
	addi $t0, $zero, -1
	bne $v0, $t0, instackeven #if in stack, delete the edge because it will not used
	addi $t0, $s0, 1
	sll $t0, $t0, 2
	add $t0, $a0, $t0
	lw $t0, 0($t0)
	slt $t1, $t0, $s2
	bne $t1, $zero, ismineven #if not in stack and destination value is less than result value, change result
	addi $s0, $s0, 1
	j saloop

instackeven: #index is even, dest is in stack
	sll $t0, $s0, 2
	add $t0, $a0, $t0
	addi $t1, $zero, 0
	sw $t1, 0($t0)
	sw $t1, 4($t0) #store zero in the edge address
	addi $s0, $s0, 1
	j saloop #go to loop

ismineven: #index is even, dest is not in stack and minimal until now
	sll $t0, $s0, 2
	add $t0, $a0, $t0
	lw $s2, 4($t0)
	addi $s3, $s0, 0
	addi $s0, $s0, 1
	j saloop

oddcase: #if index is odd
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)

	addi $t0, $a3, 0
	addi $t1, $s0, -1
	sll $t1, $t1, 2
	add $t1, $t1, $a0
	lw $t1, 0($t1)
	lw $t2, 0($a2)
	

	addi $a0, $t0, 0
	addi $a1, $t1, 0
	addi $a2, $t2, 0

	jal stacksearch #same as even case

	lw $ra, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16
	addi $t0, $zero, -1
	bne $v0, $t0, instackodd


	addi $t0, $s0, -1
	sll $t0, $t0, 2
	add $t0, $a0, $t0
	lw $t0, 0($t0)
	slt $t1, $t0, $s2
	bne $t1, $zero, isminodd
	addi $s0, $s0, 1
	j saloop

instackodd: #index is odd, dest is in stack
	sll $t0, $s0, 2
	add $t0, $a0, $t0
	addi $t1, $zero, 0
	sw $t1, 0($t0)
	sw $t1, -4($t0) #store zero in the address of edge
	addi $s0, $s0, 1
	j saloop

isminodd: #index is odd, dest is not in stack, dest is minimal until now
	sll $t0, $s0, 2
	add $t0, $a0, $t0
	lw $s2, -4($t0)
	addi $s3, $s0, -1
	addi $s0, $s0, 1 #change result and the address value
	j saloop #go to loop again

exitsa1: #store smallest destination in ministack
	addi $t0, $zero, -1
	addi $t1, $s3, 0
	beq $t1, $t0, exitsa2 #if result address is same as initial case, end stackingall
	addi $t2, $zero, 0
	sll $t1, $t1, 2
	add $t1, $t1, $a0
	sw $t2, 0($t1)
	sw $t2, 4($t1) #delete edge of smallest destination it will not used again
	
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	addi $a0, $a3, 0
	lw $t0, 0($a2)
	addi $a1, $t0, 1
	jal lastzero
	lw $ra, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12
	
	addi $t0, $v0, 0
	sll $t0, $t0, 2
	add $t0, $a3, $t0
	sw $s2, 0($t0)  #store smallest dest in stack

	j stackingall #recursively stack smallest vertexs until there is no edges of target vertex
	

exitsa2: #end stackingall
	addi $v0, $zero, 0
	jr $ra
	
minvertex: #function used in dfs different from stackingall, it make sure smallest destination, then search ministack because dfs should go through deep root.
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)

	lw $t0, 4($a2)
	sll $t0, $t0, 1
	addi $a2, $t0, 0
	jal search #check target is in edge first

	lw $ra, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16

	addi $t0, $zero, -1
	beq $v0, $t0, exitmv2 #if not, end minvertex

	addi $s0, $zero, 0 #index
	lw $t2, 4($a2)
	add $s1, $t2, $t2 #number of iteration
	add $s2, $t2, $t2 #initial result
	addi $s3, $zero, -1 #initial result address
	j mvloop

mvloop:
	slt $t3, $s0, $s1
	beq $t3, $zero, mvrmed #end of iteration, go to removing edge step

	sll $t3, $s0, 2
	add $t3, $t3, $a0
	lw $t3, 0($t3)
	beq $t3, $a1, iseven2 #if target dest detected
	addi $s0, 1
	j mvloop

iseven2: #as before, determine whether index is even or not
	andi $t4, $s0, 1
	beq $t4, $zero, evencase2
	j oddcase2

evencase2: #if dest is smaller than current result, change result in even case
	addi $t0, $s0, 1
	sll $t0, $t0, 2
	add $t0, $a0, $t0
	lw $t0, 0($t0)
	slt $t1, $t0, $s2
	bne $t1, $zero, ismineven2
	addi $s0, $s0, 1
	j mvloop

ismineven2: #change result in even case
	sll $t0, $s0, 2
	add $t0, $a0, $t0
	lw $s2, 4($t0)
	addi $s3, $s0, 0
	addi $s0, $s0, 1
	j mvloop

oddcase2: #if dest is smaller than current result, change result in odd case
	addi $t0, $s0, -1
	sll $t0, $t0, 2
	add $t0, $a0, $t0
	lw $t0, 0($t0)
	slt $t1, $t0, $s2
	bne $t1, $zero, isminodd2
	addi $s0, $s0, 1
	j mvloop

isminodd2: #change result in odd case
	sll $t0, $s0, 2
	add $t0, $a0, $t0
	lw $s2, -4($t0)
	addi $s3, $s0, -1
	addi $s0, $s0, 1
	j mvloop

mvrmed: #remove edges from result vertex that keep procedure from revisit vertexs
	addi $s0, $zero, 0
	j rmedloop

rmedloop: #find all edge from result and determine whether new dest is in stack
	slt $t3, $s0, $s1
	beq $t3, $zero, exitmv1

	sll $t3, $s0, 2
	add $t3, $t3, $a0
	lw $t3, 0($t3)
	beq $t3, $s2, foundmv
	addi $s0, 1
	j rmedloop

foundmv: #similarly divide case in even and odd
	andi $t4, $s0, 1
	beq $t4, $zero, evencase3
	j oddcase3

evencase3: #search new dest in stack then remove the edges
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	addi $t0, $s0, 1
	sll $t0, $t0, 2
	add $t0, $a0, $t0
	addi $a0, $a3, 0
	lw $a1, 0($t0)
	lw $a2, 0($a2) 
	jal stacksearch

	lw $ra, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16
	addi $t0, $zero, -1
	bne $v0, $t0, instackeven2 #if new dest is in stack
	addi $s0, $s0, 1
	j rmedloop

instackeven2: #delete edges of instack dest in case when index is even 
	sll $t0, $s0, 2
	add $t0, $a0, $t0
	addi $t1, $zero, 0
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	addi $s0, $s0, 1
	j rmedloop

oddcase3: #search new dest in stack then remove the edges
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	addi $t0, $s0, -1
	sll $t0, $t0, 2
	add $t0, $a0, $t0
	addi $a0, $a3, 0
	lw $a1, 0($t0)
	lw $a2, 0($a2)
	jal stacksearch

	lw $ra, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16
	addi $t0, $zero, -1
	bne $v0, $t0, instackodd2 #if new dest is in stack
	addi $s0, $s0, 1
	j rmedloop

instackodd2: #delete edges of instack dest in case when index is odd
	sll $t0, $s0, 2
	add $t0, $a0, $t0
	addi $t1, $zero, 0
	sw $t1, 0($t0)
	sw $t1, -4($t0)
	addi $s0, $s0, 1
	j rmedloop

exitmv1: #delete edge from initial target to result and return result vertex
	addi $t0, $zero, -1
	beq $s3, $t0, exitmv2
	sll $t0, $s3, 2
	add $t0, $a0, $t0
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	addi $v0, $s2, 0
	jr $ra

exitmv2: #end minvertex if there is no dest from target or initial address did not change
	addi $v0, $zero, 0
	jr $ra

dfs:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	lw $t0, 0($a0)
	addi $a0, $a3, 0
	addi $a1, $t0, 0
	jal lastzero
	lw $ra, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12 
	addi $t0, $v0, 0
	sll $t0, $t0, 2
	add $t0, $a3, $t0
	sw $a1, 0($t0) #stack current vertex in ministack
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)

	addi $a0, $a1, 0
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall

	lw $a0, 0($sp) 
	addi $sp, $sp, 4 #print current vertex

	lw $t0, 0($a3)
	addi $t0, $t0, -1
	sw $t0, 0($a3) #decrease stack point by one
	
	beq $t0, $zero, enddfs #if stackpoint is zero, end dfs
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	lw $t0, 4($a0)
	add $t0, $t0, $t0
	addi $a1, $t0, 0
	addi $a0, $a2, 0
	jal allzero
	lw $ra, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12
	bne $v0, $zero, enddfs #if all edges are deleted, end dfs
	
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	addi $t0, $a2, 0
	addi $t1, $a1, 0
	lw $t2, 4($a0) 
	add $t2, $t2, $t2
	addi $a0, $t0, 0
	addi $a1, $t1, 0
	addi $a2, $t2, 0
	jal search
	lw $ra, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16 #check if edges from current vertex exist

	addi $t0, $zero, -1
	beq $t0, $v0, back #if cannot go through current vertex go back and search from stack
	
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a3, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	addi $t0, $a2, 0
	addi $t2, $a0, 0
	addi $a0, $t0, 0
	addi $a2, $t2, 0
	jal minvertex
	lw $ra, 16($sp)
	lw $a3, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 20 #if we can go through, run minvertex and determine next vertex
	
	addi $t0, $v0, 0
	addi $a1, $t0, 0
	j dfs #recursively run dfs with changed current vertex

back: #search ministack backward and search new branch
	addi $s0, $zero, 0
	lw $s1, 0($a0)
	j backloop

backloop:
	slt $t0, $s0, $s1
	beq $t0, $zero, exitdfs # search through stack from last nonzero elements
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	addi $t0, $a3, 0
	lw $t1, 0($a0) 
	addi $a0, $t0, 0
	addi $a1, $t1, 0
	jal lastzero
	lw $ra, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12 
	
	addi $t0, $v0, -1
	addi $t7, $zero, 1
	beq $t7, $t0, enddfs	
	sll $t0, $t0, 2
	add $t0, $a3, $t0
	sw $zero, 0($t0)
	lw $s2, -4($t0) #delete last nonzero element because from there I found before there is no dest 

	addi $sp, $sp, -16 #then search edges from element right before deleted element if cannot, delete it also iteratively
	sw $ra, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	addi $t0, $a2, 0
	lw $t2, 4($a0)
	add $t2, $t2, $t2

	addi $a0, $t0, 0
	addi $a1, $s2, 0
	addi $a2, $t2, 0

	jal search
	lw $ra, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16
	
	addi $t0, $zero, -1
	bne $t0, $v0, nextbr #if succeed finding brance from element in ministack
	addi $s0, $s0, 1
	j backloop

nextbr: #search new next dest from new start
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a3, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	
	addi $t0, $a2, 0
	addi $t1, $s2, 0
	addi $t2, $a0, 0
	addi $t3, $a3, 0

	addi $a0, $t0, 0
	addi $a1, $t1, 0
	addi $a2, $t2, 0
	addi $a3, $t3, 0

	jal minvertex #find minvertex from new start
	
	lw $ra, 16($sp)
	lw $a3, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 20

	addi $t1, $v0, 0
	addi $a1, $t1, 0
	j dfs #reculsively run dfs with next current vertex

enddfs: #end dfs with changing line
	la $a0, chline
	li $v0, 4
	syscall
	jr $ra

exitdfs: 
	jr $ra

bfs:
	lw $t0, 0($a3)
	beq $t0, $zero, initialcase
	j bfs2

initialcase: #in initial case, store current vertex in ministack
	sw $a1, 4($a3)
	j bfs2

bfs2:
	addi $sp, $sp, -4
	sw $a0, 0($sp)

	addi $a0, $a1, 0
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall 

	lw $a0, 0($sp)
	addi $sp, $sp, 4 #print current vertex

	lw $t0, 0($a3)
	addi $t0, $t0, 1
	sw $t0, 0($a3)
	lw $t0, 0($a0)
	lw $t1, 0($a3)
	beq $t0, $t1, endbfs #if stack pointer go end, end bfs
	
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a3, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)

	addi $t0, $a2, 0
	addi $t1, $a1, 0
	addi $t2, $a0, 0
	addi $t3, $a3, 0

	addi $a0, $t0, 0
	addi $a1, $t1, 0
	addi $a2, $t2, 0
	addi $a3, $t3, 0
	
	jal stackingall

	lw $ra, 16($sp)
	lw $a3, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 20 #stack all dests from start vertex
	
	lw $t0, 0($a3)
	addi $t0, $t0, 1
	sll $t0, $t0, 2
	add $t0, $a3, $t0
	lw $t0, 0($t0)
	beq $t0, $zero, endbfs #if vertex stackpointer indicate do not exist, end bfs 
	addi $a1, $t0, 0
	
	j bfs

endbfs:
	addi $v0, $zero, 0 
	jr $ra
	

                                             




