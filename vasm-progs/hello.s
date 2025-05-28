    .org $8000

    .include io.s
    .include lcd.s

reset:
    ; Init stack pointer
    ldx #$ff
    txs

    ; Reset LCD
    jsr lcd_reset

    ldx #0
print:
    lda message,x
    beq loop        ; Exit print loop
    jsr lcd_print_char
    inx
    jmp print

loop:
    jmp loop

message: .asciiz "Hello, Landsy!"

    .org $fffc
    .word reset
    .word $0000
