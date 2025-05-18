LCD_ENABLE    = %10000000
LCD_READ      = %01000000
LCD_MODE_DATA = %00100000

lcd_reset:
    lda #%11100000  ; Set data direction (top 3 pins) port A to output
    sta IO_DDRA
    lda #%11111111  ; Set data direction (all pins) port B to output
    sta IO_DDRB
    lda #0          ; Clear LCD control inputs
    sta IO_PORTA

    lda #%00111000  ; Set 8-bit, 2-line, 5x8 font
    jsr lcd_instruction
    lda #%00001100  ; Display on, cursor off, blink off
    jsr lcd_instruction
    lda #%00000110  ; Draw left to right, don't scroll
    jsr lcd_instruction
    lda #%00000001  ; Clear display
    jsr lcd_instruction

    rts

lcd_wait:
    pha             ; Save A register
    lda #%00000000  ; Set Port B pins to input
    sta IO_DDRB

lcd_wait_busy:
    lda #LCD_READ
    sta IO_PORTA
    lda #(LCD_READ | LCD_ENABLE)
    sta IO_PORTA
    lda IO_PORTB    ; Read busy flag
    and #%10000000  ; Ignore all but the busy flag
    bne lcd_wait_busy

    lda #0          ; Clear LCD control inputs
    sta IO_PORTA
    lda #%11111111  ; Set Port B pins to output
    sta IO_DDRB
    pla             ; Restore A register

    rts

lcd_instruction:
    jsr lcd_wait
    sta IO_PORTB
    lda #LCD_ENABLE ; Enable LCD
    sta IO_PORTA
    lda #0          ; Clear LCD control inputs
    sta IO_PORTA

    rts

lcd_print_char:
    jsr lcd_wait
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_MODE_DATA) ; Enable LCD in data mode
    sta IO_PORTA
    lda #0                            ; Clear LCD control inputs
    sta IO_PORTA

    rts
