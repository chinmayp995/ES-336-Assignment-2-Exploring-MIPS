

.data
arr:    .word 5, 12, 23, 34, 45, 55, 67, 78, 89, 99

msg_search: .asciiz "Searching for: "
msg_found:  .asciiz " -> Found at index: "
msg_nfound: .asciiz " -> Not Found (-1)\n"
msg_nl:     .asciiz "\n"

.text
.globl main

main:
    # Searching 55
    la   $a0, arr
    li   $a1, 0             
    li   $a2, 9             
    li   $a3, 55           
    jal  binary_search      

    li   $v0, 4
    la   $a0, msg_search
    syscall
    li   $v0, 1
    li   $a0, 55
    syscall
    move $s0, $v0    

    # Re-running search to get $v0 back (syscall overwrites $v0)
    la   $a0, arr
    li   $a1, 0
    li   $a2, 9
    li   $a3, 55
    jal  binary_search

    li   $t0, -1
    beq  $v0, $t0, print_nf1
    li   $v0, 4
    la   $a0, msg_found
    syscall
    # result already in $v0 from jal but syscall clobbered it so Using $s0 saved earlier
    la   $a0, arr
    li   $a1, 0
    li   $a2, 9
    li   $a3, 55
    jal  binary_search
    move $s0, $v0
    li   $v0, 1
    move $a0, $s0
    syscall
    li   $v0, 4
    la   $a0, msg_nl
    syscall
    j    search2

print_nf1:
    li   $v0, 4
    la   $a0, msg_nfound
    syscall

search2:
    # Searching 100
    la   $a0, arr
    li   $a1, 0
    li   $a2, 9
    li   $a3, 100
    jal  binary_search
    move $s1, $v0

    li   $v0, 4
    la   $a0, msg_search
    syscall
    li   $v0, 1
    li   $a0, 100
    syscall

    li   $t0, -1
    beq  $s1, $t0, print_nf2

    li   $v0, 4
    la   $a0, msg_found
    syscall
    li   $v0, 1
    move $a0, $s1
    syscall
    li   $v0, 4
    la   $a0, msg_nl
    syscall
    j    exit_prog

print_nf2:
    li   $v0, 4
    la   $a0, msg_nfound
    syscall

exit_prog:
    li   $v0, 10
    syscall


binary_search:	# binary_search($a0=arr, $a1=low, $a2=high, $a3=key)Returns $v0 = index if found, -1 if not found and a Non-leaf func saves $ra and $s2
    addi $sp, $sp, -8
    sw   $ra, 4($sp)
    sw   $s2, 0($sp)

    move $s2, $a0      

bs_loop:
    slt  $t0, $a2, $a1      #if high < low
    bne  $t0, $0, bs_fail

    add  $t1, $a1, $a2
    srl  $t1, $t1, 1        # mid=(low+high)/2

    sll  $t2, $t1, 2
    add  $t2, $s2, $t2
    lw   $t3, 0($t2)        

    beq  $t3, $a3, bs_found

    slt  $t4, $t3, $a3     
    beq  $t4, $0, bs_left

    addi $a1, $t1, 1        # low=mid+1
    j    bs_loop

bs_left:
    addi $a2, $t1, -1       # high=mid-1
    j    bs_loop

bs_found:
    move $v0, $t1
    j    bs_exit

bs_fail:
    li   $v0, -1

bs_exit:
    lw   $ra, 4($sp)
    lw   $s2, 0($sp)
    addi $sp, $sp, 8
    jr   $ra