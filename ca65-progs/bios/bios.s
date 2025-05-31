  .setcpu "65C02"
  .debuginfo
  .segment "BIOS"

  .include "io.s"
  .include "wozmon.s"

  .segment "RESETVEC"
                .word   $0F00          ; NMI vector
                .word   RESET          ; RESET vector
                .word   $0000          ; IRQ vector
