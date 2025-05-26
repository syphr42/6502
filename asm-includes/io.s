; ---
; Constants for addressing the versatile interface adapter.
; ---

; Register A
IO_DDRA   = $6003   ; 1 byte
IO_PORTA  = $6001   ; 1 byte

; Register B
IO_DDRB   = $6002   ; 1 byte
IO_PORTB  = $6000   ; 1 byte

; Timer 1
IO_T1CL   = $6004   ; 1 byte
IO_T1CH   = $6005   ; 1 byte
IO_T1LL   = $6006   ; 1 byte
IO_T1LH   = $6007   ; 1 byte

; Timer 2
IO_T2CL   = $6008   ; 1 byte
IO_T2CH   = $6009   ; 1 byte

; Shift Register
IO_SR     = $600a   ; 1 byte

; Auxilliary Control Register
IO_ACR    = $600b   ; 1 byte

; Peripheral Control Register
IO_PCR    = $600c   ; 1 byte

; Interrupt Flag Register
IO_IFR    = $600d   ; 1 byte

; Interrupt Enable Register
IO_IER    = $600e   ; 1 byte

; Register A with no handshake
IO_PORTAN = $600f   ; 1 byte
