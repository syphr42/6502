; ---
; Generic I/O subroutines.
; ---

; ***
; Initialize input buffer 1.
;
; Requires that the following variables be defined:
;   IO_BUFFER_1_READ_PTR (1 byte)
;   IO_BUFFER_1_WRITE_PTR (1 byte)
;   IO_BUFFER_1 (256 bytes)
; ***
; @RegisterAModified
; @FlagsModified
io_init_buffer_1:
    lda IO_BUFFER_1_READ_PTR    ; Buffer is 256b so value does not matter
    sta IO_BUFFER_1_WRITE_PTR   ; Sync write pointer with read pointer
    rts                         ; Return

; ***
; Write data from register A into I/O buffer 1.
;
; >|registerA:  data to store in the buffer
; ***
; @FlagsModified
io_write_buffer_1:
    phx                         ; Save X register to stack

    ldx IO_BUFFER_1_WRITE_PTR   ; Load write pointer into register X
    sta IO_BUFFER_1,x           ; Store A register into buffer at offset X
    inc IO_BUFFER_1_WRITE_PTR   ; Increment write pointer

    plx                         ; Restore X register from stack
    rts                         ; Return

; ***
; Read data from I/O buffer 1 into register A if data is available.
;
; <|registerA:  value pulled from the buffer
; <|flags:      carry flag indicates data was read
; ***
; @RegisterAModified
; @FlagsModified
io_read_buffer_1:
    phx                         ; Save X register to stack

    jsr io_buffer_1_unread_size ; Check if buffer has data
    beq @no_data_available      ; Return if no data found
    ldx IO_BUFFER_1_READ_PTR    ; Load read pointer into register X
    lda IO_BUFFER_1,x           ; Read buffer at offset X into A register
    inc IO_BUFFER_1_READ_PTR    ; Increment read pointer
    sec                         ; Set carry flag
    jmp @return                 ; Exit subroutine

@no_data_available:
    clc                         ; Clear carry flag

@return:
    plx                         ; Restore X register from stack
    rts                         ; Return

; ***
; Calculate how much unread data is in I/O buffer 1.
;
; <|registerA:  size of the unread data
; ***
; @RegisterAModified
; @FlagsModified
io_buffer_1_unread_size:
    lda IO_BUFFER_1_WRITE_PTR   ; Load write pointer into register A
    sec                         ; Set carry bit
    sbc IO_BUFFER_1_READ_PTR    ; Subtract with carry read ptr from write ptr
    rts                         ; Return

; ---
; Constants for addressing the asynchronous communications interface adapter
; (ACIA).
;
; Address space: 0x5000 - 0x5FFF
; ---

IO_ACIA_DATA   = $5000     ; 1 byte
IO_ACIA_STATUS = $5001     ; 1 byte
IO_ACIA_CMD    = $5002     ; 1 byte
IO_ACIA_CTRL   = $5003     ; 1 byte

; ---
; Subroutines for interacting with the asynchronous communications interface
; adapter (ACIA).
; ---

; ***
; Input a character from the serial interface.
;
; <|registerA:   key value
; <|flags:       carry flag indicates key was pressed
; ***
; @RegisterAModified
; @FlagsModified
io_acia_char_in:
    lda     IO_ACIA_STATUS      ; Read ACIA status register
    ldx     IO_ACIA_DATA
    pha
    and     #$04
    beq     @no_overrun
    lda     #$21
    jsr     lcd_print_char
@no_overrun:
    pla
    and     #$08                ; Check for receive data
    beq     @no_key_pressed     ; If no receive data, exit
    txa
    ; lda     IO_ACIA_DATA        ; If receive data indicated, read it
    jsr     io_acia_char_out    ; Echo key press back
    sec                         ; Set carry flag
    rts                         ; Return
@no_key_pressed:
    clc                         ; Clear carry flag
    rts                         ; Return

; ***
; Output a character to the serial interface.
;
; >|registerA:  character to send
; ***
; @FlagsModified
io_acia_char_out:
    pha                         ; Save reg A to stack
    sta     IO_ACIA_DATA        ; Send character to serial interface
    lda     #$FF                ; Set counter to 255
@tx_delay:
    dec                         ; Decrement counter
    bne     @tx_delay           ; Continue loop until counter reaches 0
    pla                         ; Restore reg A from stack
    rts                         ; Return


; ---
; Constants for addressing the versatile interface adapter (VIA).
;
; Address space: 0x6000 - 0x6FFF
; ---

; Register A
IO_VIA_DDRA   = $6003   ; 1 byte
IO_VIA_PORTA  = $6001   ; 1 byte

; Register B
IO_VIA_DDRB   = $6002   ; 1 byte
IO_VIA_PORTB  = $6000   ; 1 byte

; Timer 1
IO_VIA_T1CL   = $6004   ; 1 byte
IO_VIA_T1CH   = $6005   ; 1 byte
IO_VIA_T1LL   = $6006   ; 1 byte
IO_VIA_T1LH   = $6007   ; 1 byte

; Timer 2
IO_VIA_T2CL   = $6008   ; 1 byte
IO_VIA_T2CH   = $6009   ; 1 byte

; Shift Register
IO_VIA_SR     = $600a   ; 1 byte

; Auxilliary Control Register
IO_VIA_ACR    = $600b   ; 1 byte

; Peripheral Control Register
IO_VIA_PCR    = $600c   ; 1 byte

; Interrupt Flag Register
IO_VIA_IFR    = $600d   ; 1 byte

; Interrupt Enable Register
IO_VIA_IER    = $600e   ; 1 byte

; Register A with no handshake
IO_VIA_PORTAN = $600f   ; 1 byte
