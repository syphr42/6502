    .setcpu "65C02"
    .debuginfo


    .zeropage
                        .org $A0
IO_BUFFER_1_READ_PTR:   .res 1
IO_BUFFER_1_WRITE_PTR:  .res 1

    .segment "IO_BUFFERS"
IO_BUFFER_1:            .res $100       ; Must be 256 bytes


    .segment "BIOS"

    .include "io.s"
    .include "lcd.s"

IRQ_HANDLER:
    pha                                 ; Save A register to stack
    phx

    jsr     io_acia_char_in             ; Read character from ACIA
    bcc     @return                     ; Exit if no character was read
    jsr     io_write_buffer_1           ; Write character to I/O buffer 1
    jsr     lcd_print_char
    cmp     #$0d
    bne     @return
    jsr     lcd_clear

@return:
    plx
    pla                                 ; Restore register A from stack
    rti                                 ; Return

    .include "wozmon.s"


    .segment "RESETVEC"
    .word   $0F00                       ; NMI vector
    .word   RESET                       ; RESET vector
    .word   IRQ_HANDLER                 ; IRQ vector
