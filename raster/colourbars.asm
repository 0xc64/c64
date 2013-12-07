; Program: Colour raster bars
; Author: Andrew Burch
; Site: www.0xc64.com
; Assembler: win2c64
; Notes: Use raster interrupts to generate
;		colour raster bars
;

colmap      .equ $d800              ; colour map address
counter     .equ $fa                ; raster counter

            .org $c000              ; begin (49152)

init        jsr $e544               ; clear screen

            ldx #00                 ; set colour map
            lda #00
            sta colmap, x
            inx
            cpx #80
            bne init+7

            lda #00                 ; set background & screen
            sta $d020
            sta $d021

inittext    ldx #00                 ; output text
            lda text, x
            sta $0400, x
            inx
            cpx #80                 ; text length
            bne inittext+2

            sei                     ; set up interrupt
            lda #$7f
            sta $dc0d               ; turn off the CIA interrupts
            sta $dd0d

            lda #01                 ; enable raster interrupts
            sta $d01a

            lda #$1b
            sta $d011

            ldy #49                 ; trigger just before first screen line
            sty $d012

            lda #<colourbars        ; load interrupt address
            ldx #>colourbars
            sta $0314
            stx $0315

            asl $d019
            cli
forever     jmp forever             ; loop forever

colourbars  asl $d019               ; acknowledge interrupt	

            lda #00                 ; init raster counter
            sta counter

            ldx index
            ldy counter
            lda delaytable, y
            sbc #01
            bne colourbars+15
            lda colourtable, x      ; set background colour
            sta $d021
            inx
            txa
            and #15
            tax
            iny
            cpy #16
            nop
            bne colourbars+12

resetColour ldy #8                  ; back to black background
            dey
            bne resetColour+2
            ldy #0
            sty $d021

            lda #<update            ; point to next interrupt
            ldx #>update
            sta $0314
            stx $0315

            lda #250                ; set trigger line
            sta $d012			
            jmp $ea81

update      dec smooth              ; apply smoothing to animation
            bne update+20
            lda #03
            sta smooth
            lda index               ; cycle start colour
            adc #01
            and #15
            sta index

            asl $d019               ; acknowledge interrupt

            lda #<colourbars        ; point to next interrupt
            ldx #>colourbars
            sta $0314
            stx $0315

            lda #49                 ; set trigger line
            sta $d012

            jmp $ea81

index       .byte 00                ; starting colour index
smooth      .byte 03                
delaytable  .byte 08, 03, 08, 08, 08, 08, 08, 08
            .byte 08, 03, 08, 08, 08, 08, 08, 04
colourtable .byte 13, 03, 14, 04, 06, 04, 14, 13
            .byte 07, 10, 08, 02, 09, 02, 08, 10
text        .byte 173, 160, 146, 129, 147, 148, 133, 146 
            .byte 160, 131, 143, 140, 143, 149, 146, 160 
            .byte 131, 153, 131, 140, 133, 160, 155, 151 
            .byte 151, 151, 174, 176, 152, 131, 182, 180 
            .byte 174, 131, 143, 141, 157, 160, 173, 160
            .byte 160, 160, 160, 160, 160, 160, 131, 143
            .byte 140, 143, 149, 146, 160, 147, 144, 140
            .byte 137, 148, 160, 129, 131, 146, 143, 147
            .byte 147, 160, 177, 182, 160, 140, 137, 142
            .byte 133, 147, 160, 160, 160, 160, 160, 160