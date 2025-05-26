ACIA_DATA   = $5000
ACIA_STATUS = $5001
ACIA_CMD    = $5002
ACIA_CTRL   = $5003

    .org $8000

    .include io.s
    .include lcd.s

reset:
    ; Init stack pointer
    ldx #$ff
    txs

    ; Reset LCD
    jsr lcd_reset

    ; Configure serial UART (ACIA)
    lda #$1f        ; N-8-1, 19200 baud
    sta ACIA_CTRL
    lda #$0b        ; no parity, no echo, no interrupts
    sta ACIA_CMD

rx_wait:
    lda ACIA_STATUS
    and #$08        ; Check receive data register full
    beq rx_wait

rx_read:
    lda ACIA_DATA
    jsr lcd_print_char
    jmp rx_wait

nmi:
irq:
irq_exit:
    bit IO_PORTA    ; Clear interrupt by reading port A
    rti             ; Return from interrupt

    .org $fffa
    .word nmi
    .word reset
    .word irq
