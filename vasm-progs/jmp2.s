    .org $8000

reset:
    cli
    lda #$40

start:
    asl             ; multiply A by 2
    tax             ; transfer A to X
    jmp (TABLE,X)   ; $8005 - target is $8088+X

TABLE:
    nop   ; $8008

    .org $8088
    DW  ROUTINE0,ROUTINE1,ROUTINE2   ; $8088

ROUTINE0:
    lda #$41        ; $808E
    jmp start

ROUTINE1:
    lda #$42        ; $8093
    jmp start

ROUTINE2:
    lda #$40        ; $8098
    jmp start

irq:
    ldy #$01
    nop
    nop
    nop
    rti

nmi:
    ldy #$02
    nop
    nop
    nop
    rti

    .org $fffa
    .word nmi
    .word reset
    .word irq
