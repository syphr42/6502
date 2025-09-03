    .org $0000
    .org $8000

reset:
    lda #$40

start:
    asl             ; multiply A by 2
    tax             ; transfer A to X
    jmp (TABLE,X)   ; $8006 - target is $8007+X

TABLE:
    nop   ; $8007

    .org $8087
    DW  ROUTINE0,ROUTINE1,ROUTINE2   ; $8087

ROUTINE0:
    lda #$41        ; $808D
    jmp start

ROUTINE1:
    lda #$42        ; $8092
    jmp start

ROUTINE2:
    lda #$40        ; $8097
    jmp start

    .org $fffc
    .word reset
    .word $0000
