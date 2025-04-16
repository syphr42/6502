IO_DDRA  = $6003
IO_PORTA = $6001
IO_DDRB  = $6002
IO_PORTB = $6000

LCD_ENABLE     = %10000000
LCD_READ_WRITE = %01000000
LCD_REG_SELECT = %00100000

    .org $8000

reset:
    lda #%11100000  ; Set data direction (top 3 pins) port A to output
    sta IO_DDRA
    lda #%11111111  ; Set data direction (all pins) port B to output
    sta IO_DDRB
    lda #0          ; Clear LCD control inputs
    sta IO_PORTA

    lda #%00111000  ; Set 8-bit, 2-line, 5x8 font
    sta IO_PORTB
    lda #LCD_ENABLE ; Enable LCD
    sta IO_PORTA
    lda #0          ; Clear LCD control inputs
    sta IO_PORTA

    lda #%00001110  ; Display on, cursor on, blink off
    sta IO_PORTB
    lda #LCD_ENABLE ; Enable LCD
    sta IO_PORTA
    lda #0          ; Clear LCD control inputs
    sta IO_PORTA

    lda #%00000110  ; Draw left to right, don't scroll
    sta IO_PORTB
    lda #LCD_ENABLE ; Enable LCD
    sta IO_PORTA
    lda #0          ; Clear LCD control inputs
    sta IO_PORTA

    lda #%00000001  ; Clear display
    sta IO_PORTB
    lda #LCD_ENABLE ; Enable LCD
    sta IO_PORTA
    lda #0          ; Clear LCD control inputs
    sta IO_PORTA

    lda #LCD_REG_SELECT ; Select data register
    sta IO_PORTA
    lda #"H"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"e"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"l"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"l"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"o"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #","            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #" "            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"L"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"a"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"n"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"d"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"s"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"y"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA
    lda #"!"            ; Send character
    sta IO_PORTB
    lda #(LCD_ENABLE | LCD_REG_SELECT) ; Enable LCD
    sta IO_PORTA
    lda #LCD_REG_SELECT ; Disable LCD with data register still selected
    sta IO_PORTA

loop:
    jmp loop

    .org $fffc
    .word reset
    .word $0000
