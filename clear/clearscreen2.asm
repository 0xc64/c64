; Program: Screen clear example v2
; Author: andrew burch
; Assembler: win2c64
; Notes: Use chrout kernal routine to output
;		clear home character code to clear
;		screen
;

chrout	.equ $ffd2	; kernal addresss
		
		.org $c000	; begin (49512)

main	lda #$93	; clear screen char
		jsr chrout
		rts			; return to BASIC
