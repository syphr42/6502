    .org $8000

reset:
    lda #$00

start:
    asl             ; multiply A by 2
    tax             ; transfer A to X
    jmp (TABLE,X)   ; $8006 - target is $8007+X

TABLE: DW  ROUTINE0,ROUTINE1,ROUTINE2   ; $8007

ROUTINE0:
    lda #$01        ; $800D
    jmp start

ROUTINE1:
    lda #$02        ; $8012
    jmp start

ROUTINE2:
    lda #$00        ; $8017
    jmp start

    .org $fffc
    .word reset
    .word $0000
