; Program: Full screen scroll right
; Author: Andrew Burch
; Site: www.0xc64.com
; Assembler: win2c64
; Notes: Use $d016 to scroll the whole screen
;		8 pixels and then loop
;

			.org $c000		; begin (49152)

			sei				; set up interrupt
			lda #$7f
			sta $dc0d		; turn off the CIA interrupts
			sta $dd0d
			and $d011		; clear high bit of raster line
			sta $d011		

			ldy #00			; trigger on first screen line
			sty $d012

			lda #<scroll	; load interrupt address
			ldx #>scroll
			sta $0314
			stx $0315

			lda #$01 		; enable raster interrupts
			sta $d01a
			cli
			rts				; back to BASIC

scroll		jsr latch
			ldx delay		; apply delay to slow scroller down
			dex
			bne continue

			lda offset		; update scroll offset
			adc #01
			and #07
			sta offset

			lda $d016		
			and #248		; mask lower 3 bits
			adc offset		; apply scroll
			sta $d016

			ldx #02
continue	stx delay		; set delay
			asl $d019		; acknowledge interrupt
			jmp $ea81

latch		ldx #02			; stable raster delay
			dex
			bne latch+2
			rts

offset		.byte 00
delay		.byte 02