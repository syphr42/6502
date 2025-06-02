; ---
; Subroutines for interacting with the LCD device.
;
; Requires:
;   * io.s
; ---

LCD_ENABLE    = %10000000
LCD_READ      = %01000000
LCD_MODE_DATA = %00100000

;;;
; Reset the LCD device with default configuration.
;
; Set 8-bit, 2-line, 5x8 font
; Display on, cursor off, blink off
; Draw left to right, don't scroll
; Clear display
;;;
lcd_reset:
    pha             ; Save A register to stack

    lda #%11100000  ; Set data direction (top 3 pins) port A to output
    sta IO_VIA_DDRA
    lda #%11111111  ; Set data direction (all pins) port B to output
    sta IO_VIA_DDRB
    lda #0          ; Clear LCD control inputs
    sta IO_VIA_PORTA

    lda #%00111000  ; Set 8-bit, 2-line, 5x8 font
    jsr _lcd_instruction
    lda #%00001110  ; Display on, cursor on, blink off
    jsr _lcd_instruction
    lda #%00000110  ; Draw left to right, don't scroll
    jsr _lcd_instruction

    jsr lcd_clear

    pla             ; Pull A register from stack
    rts             ; Return
;;; End lcd_reset

;;;
; Set the LCD cursor to the home position.
;;;
lcd_set_cursor_home:
    pha             ; Save A register to stack

    lda #%00000010
    jsr _lcd_instruction

    pla             ; Pull A register from stack
    rts             ; Return
;;; End lcd_set_cursor_home

;;;
; Clear LCD.
;;;
lcd_clear:
    pha             ; Save A register to stack

    lda #%00000001
    jsr _lcd_instruction

    pla             ; Pull A register from stack
    rts             ; Return
;;; End lcd_set_cursor_home

;;;
; Print the value in the A register to the LCD device.
;;;
lcd_print_char:
    jsr _lcd_wait

    sta IO_VIA_PORTB    ; Send A register to the LCD
    pha                 ; Save A register to stack

    lda #(LCD_ENABLE | LCD_MODE_DATA) ; Enable LCD in data mode
    sta IO_VIA_PORTA
    lda #0                            ; Clear LCD control inputs
    sta IO_VIA_PORTA

    pla             ; Pull A register from stack
    rts             ; Return
;;; End lcd_print_char

;;;
; Private subroutine to send LCD instruction from the A register.
;;;
_lcd_instruction:
    jsr _lcd_wait

    sta IO_VIA_PORTB    ; Send A register to the LCD
    pha                 ; Save A register to stack

    lda #LCD_ENABLE     ; Enable LCD
    sta IO_VIA_PORTA
    lda #0              ; Clear LCD control inputs
    sta IO_VIA_PORTA

    pla                 ; Pull A register from stack
    rts                 ; Return
;;; End _lcd_instruction

;;;
; Private subroutine to wait for LCD to clear its busy flag.
;;;
_lcd_wait:
    pha             ; Save A register to stack

    lda #%00000000  ; Set Port B pins to input
    sta IO_VIA_DDRB

@lcd_wait_busy:
    lda #LCD_READ
    sta IO_VIA_PORTA
    lda #(LCD_READ | LCD_ENABLE)
    sta IO_VIA_PORTA
    lda IO_VIA_PORTB    ; Read busy flag
    and #%10000000      ; Ignore all but the busy flag
    bne @lcd_wait_busy

    lda #0              ; Clear LCD control inputs
    sta IO_VIA_PORTA
    lda #%11111111      ; Set Port B pins to output
    sta IO_VIA_DDRB

    pla                 ; Pull A register from stack
    rts                 ; Return
;;; End lcd_wait
