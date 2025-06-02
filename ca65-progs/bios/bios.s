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
    jsr     io_acia_load_buffer         ; Read data from serial if available
    pla                                 ; Restore register A from stack
    rti                                 ; Return

    .include "wozmon.s"


    .segment "RESETVEC"
    .word   $0F00                       ; NMI vector
    .word   RESET                       ; RESET vector
    .word   IRQ_HANDLER                 ; IRQ vector
