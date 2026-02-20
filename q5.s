
.data
matA:   .word 1,  2,  3,  4,  5
        .word 6,  7,  8,  9,  10
        .word 11, 12, 13, 14, 15
        .word 16, 17, 18, 19, 20
        .word 21, 22, 23, 24, 25

matB:   .word 1, 0, 0, 0, 0
        .word 0, 1, 0, 0, 0
        .word 0, 0, 1, 0, 0
        .word 0, 0, 0, 1, 0
        .word 0, 0, 0, 0, 1

matC:   .space 100

msg_title:  .asciiz "Result Matrix C = A x B:\n"
msg_space:  .asciiz " "
msg_nl:     .asciiz "\n"

.text
.globl main

main:
    # Initilaising matc with zero
    la   $t0, matC
    li   $t1, 0
    li   $t2, 25

zero_loop:
    beq  $t1, $t2, zero_done
    sll  $t3, $t1, 2
    add  $t3, $t0, $t3
    sw   $0,  0($t3)
    addi $t1, $t1, 1
    j    zero_loop

zero_done:
    #  Triple Nested Loop
    li   $s0, 0             # i = 0
    li   $s3, 5             # N = 5

i_loop:
    beq  $s0, $s3, print_result
    li   $s1, 0             # j = 0

j_loop:
    beq  $s1, $s3, j_done

    # Load C[i][j] address and current value
    mul  $t0, $s0, $s3      # i * N
    add  $t0, $t0, $s1      # i*N + j
    sll  $t0, $t0, 2
    la   $t9, matC
    add  $t9, $t9, $t0      # &C[i][j]
    lw   $t8, 0($t9)        # accumulator

    li   $s2, 0             # k = 0

k_loop:
    beq  $s2, $s3, k_done

    # A[i][k]
    mul  $t0, $s0, $s3
    add  $t0, $t0, $s2
    sll  $t0, $t0, 2
    la   $t1, matA
    add  $t1, $t1, $t0
    lw   $t2, 0($t1)

    # B[k][j]
    mul  $t0, $s2, $s3
    add  $t0, $t0, $s1
    sll  $t0, $t0, 2
    la   $t3, matB
    add  $t3, $t3, $t0
    lw   $t4, 0($t3)

    mul  $t5, $t2, $t4
    add  $t8, $t8, $t5      # C[i][j] += A[i][k]*B[k][j]

    addi $s2, $s2, 1
    j    k_loop

k_done:
    sw   $t8, 0($t9)        # store C[i][j]
    addi $s1, $s1, 1
    j    j_loop

j_done:
    addi $s0, $s0, 1
    j    i_loop

# Printing Result matrix
print_result:
    li   $v0, 4
    la   $a0, msg_title
    syscall

    la   $t0, matC
    li   $t1, 0             # row
    li   $t3, 5

pr_row:
    beq  $t1, $t3, exit_prog
    li   $t2, 0             # col

pr_col:
    beq  $t2, $t3, pr_row_done
    lw   $a0, 0($t0)
    li   $v0, 1
    syscall
    li   $v0, 4
    la   $a0, msg_space
    syscall
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j    pr_col

pr_row_done:
    li   $v0, 4
    la   $a0, msg_nl
    syscall
    addi $t1, $t1, 1
    j    pr_row

exit_prog:
    li   $v0, 10
    syscall