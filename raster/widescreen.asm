; Program: Wide screen effect
; Author: Andrew Burch
; Site: www.0xc64.com
; Assembler: win2c64
; Notes: Use raster interrupts to toggle
;		border colour to give the effect
;		of wide screen
;

        .org $c000      ; begin (49152)

        jsr $e544       ; clear screen
        lda #00         ; black background
        sta $d021

        sei             ; set up interrupt
        lda #$7f
        sta $dc0d       ; turn off the CIA interrupts
        sta $dd0d
        and $d011       ; clear high bit of raster line
        sta $d011		

        ldy #50         ; trigger on first screen line
        sty $d012

        lda #<widetop   ; load interrupt address
        ldx #>widetop
        sta $0314
        stx $0315

        lda #$01        ; enable raster interrupts
        sta $d01a
        cli
        rts             ; back to BASIC

widetop jsr latch
        lda #00         ; set border colour
        sta $d020
        sta $d021

        lda #<widebot   ; point to next interrupt
        ldx #>widebot
        sta $0314
        stx $0315

        lda #250        ; set trigger last screen line
        sta $d012

        asl $d019       ; acknowledge interrupt
        jmp $ea81

widebot jsr latch
        lda #06         ; set border colour
        sta $d020

        lda #<widetop   ; point to next interrupt
        ldx #>widetop
        sta $0314
        stx $0315

        ldy #50         ; set trigger scan line
        sty $d012

        asl $d019       ; acknowledge interrupt
        jmp $ea31

latch   ldx #02         ; stable raster delay
        dex 
        bne latch+2
        rts