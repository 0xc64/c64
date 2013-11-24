; Program: Single row scroll loop
; Author: Andrew Burch
; Site: www.0xc64.com
; Assembler: win2c64
; Notes: Use $d016 to scroll the single row
;		8 pixels and then loop
;

			.org $c000			; begin (49152)

plottext	ldx #39				; fill last row with characters
			lda #00
			sta $07c0, x
			adc #01
			and #15
			dex
			bpl plottext+4

			sei					; set up interrupt
			lda #$7f
			sta $dc0d			; turn off the CIA interrupts
			sta $dd0d
			and $d011			; clear high bit of raster line
			sta $d011		

			ldy #00				; trigger on first scan line
			sty $d012

			lda #<noscroll		; load interrupt address
			ldx #>noscroll
			sta $0314
			stx $0315

			lda #$01 			; enable raster interrupts
			sta $d01a
			cli
			rts					; back to BASIC

noscroll	lda $d016			; default to no scroll on start of screen
			and #248			; mask register to maintain higher bits
			sta $d016
			ldy #242			; trigger scroll on last character row
			sty $d012
			lda #<scroll		; load interrupt address
			ldx #>scroll
			sta $0314
			stx $0315
			inc $d019			; acknowledge interrupt
			jmp $ea31

scroll		lda $d016			; grab scroll register
			and #248			; mask lower 3 bits
			adc offset			; apply scroll
			sta $d016

			dec smooth			; smooth scroll
			bne continue

			dec offset			; update scroll
			bpl resetsmooth
			lda #07				; reset scroll offset
			sta offset

shiftrow	ldx #00 			; shift characters to the left
			lda $07c1, x
			sta $07c0, x
			inx
			cpx #39
			bne shiftrow+2

resetsmooth	ldx #02				; set smoothing
			stx smooth			
continue	ldy #00				; trigger on first scan line
			sty $d012
			lda #<noscroll		; load interrupt address
			ldx #>noscroll
			sta $0314
			stx $0315
			inc $d019			; acknowledge interrupt
			jmp $ea31

offset		.byte 07 			; start at 7 for left scroll
smooth		.byte 02

