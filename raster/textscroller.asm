; Program: Single row scroll loop
; Author: Andrew Burch
; Site: www.0xc64.com
; Assembler: win2c64
; Notes: Use $d016 to scroll the single row
;		8 pixels for a 1x1 text scroller
;		added colour to head and tail of text row
;

			.org $c000			; begin (49152)

			lda #00 			; black sceen & background
			sta $d020
			sta $d021

plotcolour	ldx #40				; init colour map
			lda #01
			sta $dbc0, x
			dex
			bpl plotcolour+4

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

			ldx nextchar		; insert next character
			lda message, x
			sta $07e7			
			inx
			lda message, x
			cmp #$ff			; loop message
			bne resetsmooth-3
			ldx #00
			stx nextchar

resetsmooth	ldx #01				; set smoothing
			stx smooth			

			ldx offset			; update colour map
			lda colours, x
			sta	$dbc0
			lda colours+8, x
			sta $dbc1
			lda colours+16, x
			sta	$dbe6
			lda colours+24, x
			sta $dbe7

continue	ldy #00				; trigger on first scan line
			sty $d012
			lda #<noscroll		; load interrupt address
			ldx #>noscroll
			sta $0314
			stx $0315
			inc $d019			; acknowledge interrupt
			jmp $ea31

offset		.byte 07 			; start at 7 for left scroll
smooth		.byte 01
nextchar	.byte 00
message		.byte 045, 045, 061, 032, 049, 032, 024, 032, 
			.byte 049, 032, 020, 005, 024, 020, 032, 019, 
			.byte 003, 018, 015, 012, 012, 005, 018, 032, 
			.byte 002, 025, 032, 010, 005, 019, 004, 005, 
			.byte 018, 032, 000, 032, 023, 023, 023, 046, 
			.byte 048, 024, 003, 054, 052, 046, 003, 015, 
			.byte 013, 032, 061, 045, 045, 032, 032, 032, 
			.byte 032, 032, 032, 032, 032, 032, 032, 255
colours		.byte 00, 00, 00, 00, 06, 06, 06, 06
			.byte 14, 14, 14, 14, 03, 03, 03, 03
			.byte 03, 03, 03, 03, 14, 14, 14, 14
			.byte 06, 06, 06, 06, 00, 00, 00, 00
