; Program: Screen clear example v3
; Author: andrew burch
; Assembler: win2c64
; Notes: Write 4 bytes per loop to clear
;		screen quickly
;

        .org $c000      ; begin (49152)

        lda #$20        ; space character
        ldx #00
loop    sta $0400, x    ; write 4 bytes per loop
        sta $04fa, x
        sta $05f4, x
        sta $06ee, x
        inx
        cpx #$fa
        bne loop
        rts             ; return to BASIC