
.data
# Randomly assigning 100 data points in array arr
arr: .word 15, 3, 72, 8, 45, 99, 23, 56, 11, 34
        .word 20, 60, 5, 88, 41, 77, 30, 19, 62, 48
        .word 13, 37, 91, 26, 55, 82, 10, 43, 67, 29
        .word 84, 16, 53, 74, 38, 61, 95, 7, 49, 28
        .word 70, 22, 46, 86, 33, 58, 12, 79, 40, 64
        .word 18, 92, 35, 57, 25, 73, 44, 68, 9, 83
        .word 52, 31, 76, 21, 65, 96, 14, 47, 80, 39
        .word 59, 27, 85, 42, 69, 17, 50, 93, 36, 71
        .word 24, 66, 32, 87, 54, 78, 6, 94, 63, 89
        .word 2, 98, 75, 51, 90, 4, 97, 81, 1, 100

msg_max:    .asciiz "Max Value   : "
msg_maxi:   .asciiz "Max Index   : "
msg_min:    .asciiz "Min Value   : "
msg_mini:   .asciiz "Min Index   : "
msg_avg:    .asciiz "Average     : "
newline:    .asciiz "\n"

.text
.globl main

main:
    la   $gp, arr        # Making $gp Base address of the our array arr

    # We initialise all the values with arr[0]
    lw   $s0, 0($gp)       
    lw   $s2, 0($gp)        
    li   $s1, 0             
    li   $s3, 0           
    lw   $t6, 0($gp)        # $t6 for the whole sum

    li   $t0, 1             # i = 1(iterator)
    li   $t1, 100           # N = 100 (no of iteratuons)

loop:
    beq  $t0, $t1, done     # if i == 100, then exit

    sll  $t2, $t0, 2        # byte offset = i * 4
    add  $t3, $gp, $t2      # address = base + offset
    lw   $t4, 0($t3)        # $t4 = A[i]

    add  $t6, $t6, $t4      # sum += A[i]

    # Updating the maximum
    slt  $t5, $s0, $t4      # making t5 = 1 if max < A[i]
    beq  $t5, $0, chk_min
    move $s0, $t4           # max value gets A[i]
    move $s1, $t0           # max  index gets  i

chk_min:
    # --- update min ---
    slt  $t5, $t4, $s2      # t5 = 1 if A[i] < min
    beq  $t5, $0, next
    move $s2, $t4           # min value gets A[i]
    move $s3, $t0           # min indx gets i

next:
    addi $t0, $t0, 1        # i++
    j    loop

done:
    # average = totalsum/100
    li   $t7, 100
    div  $t6, $t7
    mflo $s4                # $s4 = average

    # Printing Max Value
    li   $v0, 4
    la   $a0, msg_max
    syscall
    li   $v0, 1
    move $a0, $s0
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    # Printing Max Index
    li   $v0, 4
    la   $a0, msg_maxi
    syscall
    li   $v0, 1
    move $a0, $s1
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    # Printing Min Value
    li   $v0, 4
    la   $a0, msg_min
    syscall
    li   $v0, 1
    move $a0, $s2
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    # Printing Min Index 
    li   $v0, 4
    la   $a0, msg_mini
    syscall
    li   $v0, 1
    move $a0, $s3
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    # Printing Average
    li   $v0, 4
    la   $a0, msg_avg
    syscall
    li   $v0, 1
    move $a0, $s4
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    # Exit
    li   $v0, 10
    syscall