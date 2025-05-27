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
    jsr send_char   ; Echo
    jmp rx_wait

send_char:
    pha

    sta ACIA_DATA
    jsr tx_delay    ; Delay required due to hardware bug in ACIA

    pla
    rts

tx_delay:
    phx

    ldx #100        ; Delay approx 520 cycles @ 1MHz
tx_delay_loop$
    dex
    bne tx_delay_loop$

    plx
    rts

nmi:
irq:
irq_exit:
    bit IO_PORTA    ; Clear interrupt by reading port A
    rti             ; Return from interrupt

    .org $fffa
    .word nmi
    .word reset
    .word irq
