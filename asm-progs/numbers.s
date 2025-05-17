IO_DDRA  = $6003
IO_PORTA = $6001
IO_DDRB  = $6002
IO_PORTB = $6000

ADDR_VAL   = $0200  ; 2 bytes
ADDR_MOD10 = $0202  ; 2 bytes
ADDR_MSG   = $0204  ; 6 bytes

LCD_ENABLE    = %10000000
LCD_READ      = %01000000
LCD_MODE_DATA = %00100000

    .org $8000

reset:
    ldx #$ff
    txs             ; Init stack pointer

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

    ; Init printable message to empty string
    lda #0
    sta ADDR_MSG

    ; Save input number to RAM
    lda number
    sta ADDR_VAL
    lda number + 1
    sta ADDR_VAL + 1

divide:
    ; Init remainder to 0 and clear carry bit
    lda #0
    sta ADDR_MOD10
    sta ADDR_MOD10 + 1
    clc

    ldx #16             ; Loop counter (16-bit division)
divide_loop:
    ; Rotate quotient and remainder
    rol ADDR_VAL
    rol ADDR_VAL + 1
    rol ADDR_MOD10
    rol ADDR_MOD10 + 1

    ; a,y = dividend - divisor
    sec
    lda ADDR_MOD10
    sbc #10
    tay                 ; Save low byte into Y register
    lda ADDR_MOD10 + 1
    sbc #0
    bcc ignore_result   ; Branch if dividend < divisor
    sty ADDR_MOD10
    sta ADDR_MOD10 + 1
ignore_result:
    dex                 ; Decrement loop counter
    bne divide_loop     ; Run next iteration if loop counter not zero
    rol ADDR_VAL        ; Shift quotient one last time to capture carry bit
    rol ADDR_VAL + 1

    lda ADDR_MOD10      ; Read remainder
    clc                 ; Reset carry bit
    adc #"0"            ; Find ASCII number value by adding result to ASCII "0"
    jsr push_char       ; Push new number character to start of message string

    ; Continue division if value != 0
    lda ADDR_VAL
    ora ADDR_VAL + 1
    bne divide          ; Continue dividing using the current state of value in RAM

    ldx #0              ; Init X register counter to 0
print:
    lda ADDR_MSG,x
    beq loop            ; Exit print loop
    jsr print_char
    inx
    jmp print

loop:
    jmp loop

number: .word 65535  ; 2-byte number as input

; Add the charcter in the A register to the beginning of the
; null-terminated string `message`
push_char:
    pha                 ; Push new first char onto stack
    ldy #0              ; Init char counter to 0
push_char_loop:
    lda ADDR_MSG,y      ; Get char at counter offset from string and put into X register
    tax
    pla                 ; Pull char off stack and add it to the string
    sta ADDR_MSG,y
    iny                 ; Increment char counter
    txa                 ; Push char from X register onto stack
    pha
    bne push_char_loop  ; Continue loop if we have not found the null terminator
    pla                 ; Pull null from stack and append it to the string
    sta ADDR_MSG,y

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

print_char:
    jsr lcd_wait
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_MODE_DATA) ; Enable LCD in data mode
    sta IO_PORTA
    lda #0                            ; Clear LCD control inputs
    sta IO_PORTA
    rts

    .org $fffc
    .word reset
    .word $0000
