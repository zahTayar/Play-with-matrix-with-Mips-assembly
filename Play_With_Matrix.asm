
# Description: Play with a matrix
# Input: Menu between 1-6
# Output:Matrix after changes and before
################# Data segment #####################

.globl main
.data 
jump_table:
.word print_one
.word print_one
.word change_number
.word negatea
.word swap
matrix: .byte 122,255,34,68,56,89,156,122,135,0,33,122,122,66,18,255
#menu
option1: .asciiz "\n1.print matrix unsigned \n"
option2: .asciiz "2.print matrix sign \n"
option3: .asciiz "3.change a number in the matrix \n"
option4: .asciiz "4.negate a number in the matrix \n"
option5: .asciiz "5.swap numbers in the matrix \n"
option6: .asciiz "6.END  \n"
one_zero: .asciiz "0"
two_zero: .asciiz "00"
minus : .asciiz "-"
revah: .asciiz " "
revah1: .asciiz "  "
row: .asciiz "please enter the number of the row \n"
colu: .asciiz "please enter the number of the coluom \n"
input_msg: .asciiz "please enter the number \n"
error: .asciiz "Wrong input\nPlease try again\n"




################# Code segment #####################
.text
main:	# main program entry
loop_menu:
jal print_menu
li $v0,5
syscall

add $a1,$0,$v0#a1=choise
beq $a1,6,exit
subi $a1,$a1,1
sll $a1,$a1,2
lw $a3,jump_table($a1)#a3=name of method

jalr $a3
j loop_menu


exit: 
li $v0, 10	# Exit program
syscall
################# function #####################


print_one:

addiu $sp,$sp,-4#push to stuck
sw $ra,0($sp)
 
li $v0,11
li $a0,'\n'
syscall #next line
addi $t2,$0,4#counter of the main loop

beq $t3,$t2,finish_print#check finish
addi $t3,$t3,1
add $t0,$0,$0#counter
addi $t1,$0,4
printline:
beq $t1,$t0,print_one#check if print four numbers
lbu $a2,matrix($t4)
slti $t5,$a2,127
bne $a1,4,two_space
beq $t5,1,two_space
#do one space
li $v0,4
la $a0,revah
syscall #print revah
beq $t5,0,next
two_space:#do two spaces
li $v0,4
la $a0,revah1
syscall #print revah


#checkif need two zero before the number//positive
next:sltiu $t6,$a2,10
beq $t6,0,skip
li $v0,4
la $a0,two_zero
syscall
beq $t6,1,skip1

#check if need one zero before//positive
skip:
sltiu $t6,$a2,100
beq $t6,0,skip1
li $v0,4
la $a0,one_zero
syscall

skip1:

addi $t4,$t4,1#for index
addiu $sp,$sp,-4#push to stuck
sw $ra,0($sp)
jal print_num

lw $ra,0($sp)
addiu $sp,$sp,4
addi $t0,$t0,1# counter
j printline
################# function #####################
finish_print: 
lw $ra ,0($sp)
addiu $sp,$sp,4
add $t2,$0,$0
add $t3,$0,$0
add $t4,$0,$0
add $t1,$0,$0
add $t5,$0,$0
add $t6,$0,$0
jr $ra

print_num: 
bne $a1,4,positive

negative:
slti $t5,$a2,127
beq $t5,1,positive
subi $a2,$a2,256
sub $a2,$0,$a2 
##

li $v0,4
la $a0,minus
syscall
sltiu $t6,$a2,10#check if need tow zero/nega
beq $t6,0,skip3
li $v0,4
la $a0,two_zero
syscall
beq $t6,1,skip4

#check if need one zero before/nega
skip3:
sltiu $t6,$a2,100
beq $t6,0,skip4
li $v0,4
la $a0,one_zero
syscall

skip4:
################# function #####################
print_number:
li $v0,1
add $a0,$a2,$0
syscall #print the number 


jr $ra
################# function #####################
positive:#$a1-posi or nega, $a2 the value 

li $v0,1
add $a0,$a2,$0
syscall #print the number 

jr $ra




################# function #####################
change_number:
addiu $sp,$sp,-4#make a space in the stuck
sw $ra,0($sp)
jal get_position

li $v0,4
la $a0,input_msg
syscall #print input_msg
li $v0,5
syscall

sb $v0,matrix($t0)
jal print_one#print again to show the result 
lw $ra,0($sp)
addiu $sp,$sp,4
jr $ra

################# function #####################

get_position:
again:##wrong input
li $v0,4
la $a0,row
syscall #print row msg
li $v0,5
syscall
slti $t9,$v0,0
beq $t9,1,wrong_input
bgt $v0,3,wrong_input
add $t0,$0,$v0 #t0= number of row
li $v0,4
la $a0,colu
syscall #print colu msg
li $v0,5
syscall
slti $t9,$v0,0
beq $t9,1,wrong_input
bgt $v0,3,wrong_input
add $t1,$0,$v0 #t0= number of colu
sll $t0,$t0,2
add $t0,$t0,$t1#t0=index in the matrix

jr $ra
wrong_input:
li $v0,4
la $a0,error
syscall
j again

################# function #####################
negate:
addi $a1,$0,4
addiu $sp,$sp,-4
sw $ra,0($sp)
jal get_position
lbu $t7,matrix($t0)
xori $t2,$t7,255
addi $t2,$t2,1 
sb $t2,matrix($t0)##put t2 in the adress
jal print_one#print again to show the result 
lw $ra,0($sp)
addiu $sp,$sp,4

jr $ra

################# function #####################
swap:
addiu $sp,$sp,-4
sw $ra,0($sp)
jal get_position#use in get position
addi $t6,$0,0
addi $t3,$0,0

addi $t3,$t0,0#t3=index of the first num
lb $t6,matrix($t3)#t6=value of the first num
jal get_position
addi $t2,$0,0
lb $t2,matrix($t0)#t0=index of the second num,t2 value
sb $t6,matrix($t0)#put t6 in index t0
sb $t2,matrix($t3)#put t2 in index t3
jal print_one#print again to show the result 
lw $ra,0($sp)
addiu $sp,$sp,4 
jr $ra


################# function #####################
print_menu:
li $v0,4
la $a0,option1
syscall
li $v0,4
la $a0,option2
syscall
li $v0,4
la $a0,option3
syscall
li $v0,4
la $a0,option4
syscall
li $v0,4
la $a0,option5
syscall
li $v0,4
la $a0,option6
syscall
jr $ra




 
 
