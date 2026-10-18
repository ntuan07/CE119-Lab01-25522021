# Vai tro cac thanh ghi $s*:
#   $s0 = x      : so kWh nguoi dung nhap
#   $s1 = con tro vao mang limit (can tren cua bac hien tai)
#   $s2 = con tro vao mang price (don gia cua bac hien tai)
#   $s3 = so bac con lai chua duyet
#   $s4 = tong tien (dong)
#   $s5 = can duoi: so kWh da duoc tinh o cac bac truoc
.data
limit:   .word 50, 100, 200, 300, 400, 9999      # can tren (kWh) cua 6 bac
price:   .word 1620, 1680, 1970, 2520, 2870, 3020 # don gia (dong/kWh) cua 6 bac
nTier:   .word 6                                  # so bac
msgNhap: .asciiz "Nhap so kWh (0..9999): "
msgLoi:  .asciiz "Gia tri khong hop le, nhap lai.\n"
msgOut:  .asciiz "Tien dien: "
msgDong: .asciiz " dong\n"
.text
.globl main
main:
nhap:
    li    $v0, 4              # in loi nhac
    la    $a0, msgNhap
    syscall
    li    $v0, 5              # doc so nguyen co dau
    syscall
    move  $s0, $v0            # $s0 = x
    sltiu $t0, $s0, 10000     # SO SANH: (khong dau) x < 10000 ?
    #slti $t0, $s0, 10000     # SO SANH: (co dau) x < 10000 ?
    bne   $t0, $zero, hop_le  # NHANH: dung thi sang phan tinh tien
    li    $v0, 4              # sai: in thong bao loi
    la    $a0, msgLoi
    syscall
    j     nhap                # nhap lai	
 
hop_le:
    la    $s1, limit          # con tro dau mang can tren
    la    $s2, price          # con tro dau mang don gia
    la    $t0, nTier
    lw    $s3, 0($t0)         # $s3 = 6 bac
    li    $s4, 0              # tong = 0
    li    $s5, 0              # can duoi = 0
lap:
    beq   $s3, $zero, done    # het bac thi dung
    slt   $t0, $s5, $s0       # can duoi < x ?
    beq   $t0, $zero, done    # x <= can duoi: da tinh het dien nang
    lw    $t1, 0($s1)         # $t1 = can tren cua bac
    move  $t3, $t1            # gia su dung het bac: diem cuoi = can tren
    slt   $t2, $s0, $t1       # x < can tren ?
    beq   $t2, $zero, du_bac  # khong: bac nay dung het
    move  $t3, $s0            # co: diem cuoi = x (bac dung do)
du_bac:
    sub   $t4, $t3, $s5       # so kWh thuoc bac nay
    lw    $t5, 0($s2)         # don gia cua bac
    mul   $t4, $t4, $t5       # tien cua bac
    add   $s4, $s4, $t4       # cong don vao tong
    move  $s5, $t1            # can duoi moi = can tren cua bac vua tinh
    addi  $s1, $s1, 4         # sang phan tu ke tiep cua limit
    addi  $s2, $s2, 4         # sang phan tu ke tiep cua price
    addi  $s3, $s3, -1        # con lai it hon 1 bac
    j     lap
 
done:
    li    $v0, 4
    la    $a0, msgOut
    syscall
    li    $v0, 1              # in tong tien
    move  $a0, $s4
    syscall
    li    $v0, 4
    la    $a0, msgDong
    syscall
    li    $v0, 10             # ket thuc chuong trinh
    syscall
