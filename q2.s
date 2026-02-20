
.data
matA:   .word 1,  2,  3,  4
        .word 5,  6,  7,  8
        .word 9,  10, 11, 12
        .word 13, 14, 15, 16

matB:   .word 16, 15, 14, 13
        .word 12, 11, 10, 9
        .word 8,  7,  6,  5
        .word 4,  3,  2,  1

matC:   .space 64

msg_title:  .asciiz "Matrix C = A + B:\n"
msg_row:    .asciiz "\n"
msg_space:  .asciiz " "

.text
.globl main

main:
    la   $t0, matA
    la   $t1, matB
    la   $t2, matC
    li   $t3, 0            
    li   $t4, 16            

# Addition Loop
add_loop:
    beq  $t3, $t4, print_start

    sll  $t5, $t3, 2        # byte offset = i * 4

    add  $t6, $t0, $t5
    lw   $t7, 0($t6)        # A[i]

    add  $t8, $t1, $t5
    lw   $t9, 0($t8)        # B[i]

    add  $s0, $t7, $t9      # A[i] + B[i]

    add  $s1, $t2, $t5
    sw   $s0, 0($s1)        # ResultC[i] 

    addi $t3, $t3, 1
    j    add_loop

# Printing Result
print_start:
    li   $v0, 4
    la   $a0, msg_title
    syscall

    la   $t0, matC
    li   $t1, 0             # row = 0
    li   $t3, 4             # N = 4

row_loop:
    beq  $t1, $t3, exit_prog
    li   $t2, 0             # col = 0

col_loop:
    beq  $t2, $t3, row_done

    lw   $a0, 0($t0)        # loading C element
    li   $v0, 1
    syscall                 

    li   $v0, 4
    la   $a0, msg_space
    syscall

    addi $t0, $t0, 4        # moving  to next element
    addi $t2, $t2, 1
    j    col_loop

row_done:
    li   $v0, 4
    la   $a0, msg_row
    syscall
    addi $t1, $t1, 1
    j    row_loop

exit_prog:
    li   $v0, 10
    syscall