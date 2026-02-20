
.data
deadend:    .asciiz "DEADEND0"
msg_swapped:  .asciiz "Words were SWAPPED\n"
msg_noswap:   .asciiz "Words were NOT swapped\n"
msg_w0:       .asciiz "Word at gp+0 (hex shown as int): "
msg_w4:       .asciiz "Word at gp+4 (hex shown as int): "
msg_nl:       .asciiz "\n"

.text
.globl main

main:
    la   $gp, deadend       # $gp is the base address of "DEADEND0"

do:
    addi $a0, $0,  0        
    lw   $t1, 0($gp)        # $t1=first 4 bytes (0x44454144='DEAD')
    lw   $t2, 4($gp)        # $t2=next  4 bytes (0x454E4430='END0')
    add  $t3, $t2, $t1      # $t3=$t1+$t2
    sub  $t4, $t2, $t1      # $t4=$t2-$t1
    slt  $t5, $t4, $t3      # if $t4 < $t3, t5=1
    beq  $t5, $0, noswp     # if $t5==0, no swap
    nop
swp:
    sw   $t2, 0($gp)        
    sw   $t1, 4($gp)        

    li   $v0, 4
    la   $a0, msg_swapped
    syscall
    j    print_words

noswp:
    li   $v0, 4
    la   $a0, msg_noswap
    syscall

print_words:
    # Printing word at $gp+0
    li   $v0, 4
    la   $a0, msg_w0
    syscall
    lw   $a0, 0($gp)
    li   $v0, 1
    syscall
    li   $v0, 4
    la   $a0, msg_nl
    syscall

    # Printing word at $gp+4
    li   $v0, 4
    la   $a0, msg_w4
    syscall
    lw   $a0, 4($gp)
    li   $v0, 1
    syscall
    li   $v0, 4
    la   $a0, msg_nl
    syscall
    li   $v0, 10
    syscall