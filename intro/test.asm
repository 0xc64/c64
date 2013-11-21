; Program: Cycle screen colour
; Author: andrew burch
; Assembler: DASM
; Notes: First C64 assembly code for 20 years
;

; target processor
 processor 6502

; code origin
 org $1000

; main
loop:	inc $d021
		jmp loop
