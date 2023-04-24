nor $s0, $0, $0
nor $s1, $0, $0
add $s0, $s1, $s0
srl $s2, $s0, 2
and $s1, $s1, $s1
or $s3, $s2, $s1
xor $s4, $s2, $s1
sll $s5, $s2, 1
sra $s6, $s5, 3
slt $s7, $s6, $s5
sub $t8, $s5, $s6
addi $s0 , $0 , 12
addi $s1 , $0 , -2
while: beq $s0 , $0 , done 
add $s0 , $s0 , $s1
j while
done: addi $a0 , $a0 , 0
addi $a1 , $a1 , 10
addi $a2 , $a2 , 10
addi $a3 , $a3 , 10
sll $a2 , $a2 , 2
sll $a3 , $a3 , 2
add $v0 , $zero , $zero
add $t0 , $zero , $zero
OUTER: add $t4 , $a0 , $t0
lw $t4 , 0($t4)
add $t1 , $zero , $zero
INNER: add $t3 , $a1 , $t1
lw $t3 , 0($t3)
bne $t3 , $t4 , SKIP
addi $v0 , $v0 , 1
SKIP: addi $t1 , $t1 , 4
bne $t1 , $a3 , INNER
addi $t0 , $t0 , 4
bne $t0 , $a2 , OUTER