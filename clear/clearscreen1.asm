; Program: Screen clear example v1
; Author: andrew burch
; Assembler: win2c64
; Notes: Use chrout kernal routine to fill
;		screen with spaces
;

chrout	.equ $ffd2	; kernal addresss
plot	.equ $fff0

		.org $c000	; begin (49512)

init	clc			; init cursor position
		ldx #00
		ldy #00
		jsr plot
		lda #$20	; space chracter
		ldy #25
yloop	ldx #40
xloop	jsr chrout
		dex
		bne xloop
		dey
		bne yloop
		rts			; return to BASIC