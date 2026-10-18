# Vai tro cac thanh ghi $s*:
#   $s0 = con tro vao mang pitch   $s1 = con tro vao mang dur
#   $s2 = so not con lai           $s3 = tong thoi luong du kien (ms)
#   $s4 = thoi diem bat dau (ms)   $s5 = thoi luong (ms) cua not dang phat
.data
pitch:   .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
dur:     .word  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  3,  1,  4
nNote:   .word 15                  # so not
shift:   .word 1                   # a = 1: dich giong 1 nua cung
unit:    .word 170                 # 150 + 10*b = 170 ms moi don vi nhip
instr:   .word 40                  # nhac cu theo tham so ca nhan
msgSp:   .asciiz " "
msgNl:   .asciiz "\n"
msgTong: .asciiz "Tong du kien (ms): "
msgDo:   .asciiz "Thoi gian do duoc (ms): "
.text
.globl main
main:
    la    $s0, pitch
    la    $s1, dur
    la    $t0, nNote
    lw    $s2, 0($t0)          # $s2 = 15 not
    li    $s3, 0               # tong du kien = 0
    li    $v0, 30              # doc thoi gian he thong
    syscall
    move  $s4, $a0             # $s4 = thoi diem bat dau (32 bit thap)
lap:
    beq   $s2, $zero, het      # het not thi thoat
    lw    $t1, 0($s0)          # cao do trong mang
    lw    $t2, shift
    add   $t1, $t1, $t2        # cao do thuc phat = cao do + a
    lw    $t3, 0($s1)          # do dai (don vi nhip)
    lw    $t4, unit
    mul   $s5, $t3, $t4        # thoi luong ms = do dai * 170
    add   $s3, $s3, $s5        # cong don tong du kien
    li    $v0, 1               # in cao do
    move  $a0, $t1
    syscall
    li    $v0, 4
    la    $a0, msgSp
    syscall
    li    $v0, 1               # in thoi luong ms
    move  $a0, $s5
    syscall
    li    $v0, 4
    la    $a0, msgNl
    syscall
    move  $a0, $t1             # $a0 = cao do
    move  $a1, $s5             # $a1 = thoi luong ms
    lw    $a2, instr           # $a2 = nhac cu
    li    $a3, 100             # $a3 = am luong
    li    $v0, 33              # phat not, cho den khi het not (Cau hinh A)
    syscall
    #move  $a0, $a1     # $a0 = do dai not (ms) de ngu
    #li    $v0, 32      # syscall 32: cho (ngu)
    #syscall
    addi  $s0, $s0, 4
    addi  $s1, $s1, 4
    addi  $s2, $s2, -1
    j     lap
het:
    li    $v0, 30
    syscall                    # thoi diem ket thuc o $a0
    sub   $s4, $a0, $s4        # $s4 = thoi gian do duoc (ms)
    li    $v0, 4
    la    $a0, msgTong
    syscall
    li    $v0, 1
    move  $a0, $s3
    syscall
    li    $v0, 4
    la    $a0, msgNl
    syscall
    li    $v0, 4
    la    $a0, msgDo
    syscall
    li    $v0, 1
    move  $a0, $s4
    syscall
    li    $v0, 4
    la    $a0, msgNl
    syscall
    li    $v0, 10
    syscall
