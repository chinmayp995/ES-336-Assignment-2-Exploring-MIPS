
.data
arr:    .word 64, 25, 12, 22, 11, 90, 3, 7, 44, 55  # Input
n:      .word 10

msg_before: .asciiz "Before sort: "
msg_after:  .asciiz "After sort:  "
msg_space:  .asciiz " "
msg_nl:     .asciiz "\n"

.text
.globl main

main:
    # Printing array before sort
    li   $v0, 4
    la   $a0, msg_before
    syscall
    la   $a0, arr
    li   $a1, 10
    jal  print_array

    # QuickSort
    la   $a0, arr
    li   $a1, 0             # low  = 0
    li   $a2, 9             # high = n-1 = 9
    jal  quicksort

    # Printing array after sort
    li   $v0, 4
    la   $a0, msg_after
    syscall
    la   $a0, arr
    li   $a1, 10
    jal  print_array

    li   $v0, 10
    syscall


print_array:
    move $t0, $a0           # base
    move $t1, $a1           # length
    li   $t2, 0             # i = 0
pa_loop:
    beq  $t2, $t1, pa_done
    lw   $a0, 0($t0)
    li   $v0, 1
    syscall
    li   $v0, 4
    la   $a0, msg_space
    syscall
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j    pa_loop
pa_done:
    li   $v0, 4
    la   $a0, msg_nl
    syscall
    jr   $ra




quicksort:	# quicksort($a0=arr, $a1=low, $a2=high), a Non-leaf function thus  saves $ra, $s0-$s3 on stack (5 words = 20 bytes)
    addi $sp, $sp, -20
    sw   $ra, 16($sp)
    sw   $s0, 12($sp)
    sw   $s1,  8($sp)
    sw   $s2,  4($sp)
    sw   $s3,  0($sp)

    move $s0, $a0           # arr base
    move $s1, $a1           # low
    move $s2, $a2           # high

    # Base case: if low >= high, return
    slt  $t0, $s1, $s2      # if low < high
    beq  $t0, $0, qs_ret

    # Partition
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal  partition
    move $s3, $v0           # pivot index

    # Left half
    move $a0, $s0
    move $a1, $s1
    addi $a2, $s3, -1
    jal  quicksort

    # Right half
    move $a0, $s0
    addi $a1, $s3, 1
    move $a2, $s2
    jal  quicksort

qs_ret:
    lw   $ra, 16($sp)
    lw   $s0, 12($sp)
    lw   $s1,  8($sp)
    lw   $s2,  4($sp)
    lw   $s3,  0($sp)
    addi $sp, $sp, 20
    jr   $ra





partition:	# partition($a0=arr, $a1=low, $a2=high) returns $v0 as pivot index, a Non-leaf func thus we save $ra, $s4-$s7 on stack (5 words = 20 bytes)
    addi $sp, $sp, -20
    sw   $ra, 16($sp)
    sw   $s4, 12($sp)
    sw   $s5,  8($sp)
    sw   $s6,  4($sp)
    sw   $s7,  0($sp)

    move $s4, $a0           # arr base
    move $s5, $a2           # high

    # pivot = arr[high]
    sll  $t0, $s5, 2
    add  $t0, $s4, $t0
    lw   $s6, 0($t0)        # pivot value

    addi $s7, $a1, -1       # i = low - 1
    move $t1, $a1           # j = low

part_loop:
    slt  $t2, $t1, $s5      # 1 if j < high
    beq  $t2, $0, part_end

    sll  $t3, $t1, 2
    add  $t3, $s4, $t3
    lw   $t4, 0($t3)        

    # if arr[j] > pivot, skip
    slt  $t5, $s6, $t4     
    bne  $t5, $0, part_next

    # i++ and swap arr[i] <-> arr[j]
    addi $s7, $s7, 1
    sll  $t6, $s7, 2
    add  $t6, $s4, $t6
    lw   $t7, 0($t6)        
    sw   $t4, 0($t6)        
    sw   $t7, 0($t3)       

part_next:
    addi $t1, $t1, 1       
    j    part_loop

part_end:
    # Swappign arr[i+1] with arr[high]
    addi $s7, $s7, 1
    sll  $t0, $s7, 2
    add  $t0, $s4, $t0
    lw   $t1, 0($t0)       

    sll  $t2, $s5, 2
    add  $t2, $s4, $t2
    lw   $t3, 0($t2)       

    sw   $t3, 0($t0)        
    sw   $t1, 0($t2)      

    move $v0, $s7           # Here we return pivot index

    lw   $ra, 16($sp)
    lw   $s4, 12($sp)
    lw   $s5,  8($sp)
    lw   $s6,  4($sp)
    lw   $s7,  0($sp)
    addi $sp, $sp, 20
    jr   $ra