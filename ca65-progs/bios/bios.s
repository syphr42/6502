    .setcpu "65C02"
    .debuginfo


    .zeropage
                        .org $00
IO_BUFFER_1_READ_PTR:   .res 1
IO_BUFFER_1_WRITE_PTR:  .res 1

    .segment "IO_BUFFERS"
IO_BUFFER_1:            .res $100       ; Must be 256 bytes


    .segment "BIOS"

    .include "io.s"
    .include "lcd.s"

bios_reset:
    jsr     io_acia_reset               ; Reset the ACIA for serial comms
    jsr     lcd_reset                   ; Reset LCD
    cli                                 ; Enable CPU interrupts
    jmp     WOZMON                      ; Jump to Wozmon

bios_irq_handler:
    pha                                 ; Save A register to stack
    jsr     io_acia_load_buffer         ; Read data from serial if available
    pla                                 ; Restore register A from stack
    rti                                 ; Return

    .include "wozmon.s"


    .segment "RESETVEC"
    .word   bios_reset                  ; NMI vector
    .word   bios_reset                  ; RESET vector
    .word   bios_irq_handler            ; IRQ vector
