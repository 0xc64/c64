; Program: 16 Sprite Raster Split
; Author: Andrew Burch
; Site: www.0xc64.com
; Assembler: win2c64
; Notes: Uses a raster interrupt to produce 16
;         sprites on screen at once
;
; More info: http://www.0xc64.com/2013/12/06/sprite-split-with-rasters
;

spritepos       .equ $d000              ; sprite x/y registers
spriteposhigh   .equ $d010              ; high bit for x position
spriteenable    .equ $d015              ; sprite enable bits
spriteptr       .equ $07f8              ; sprite data pointers
spritemulti     .equ $d01c              ; multi colour enable register
spritecolour    .equ $d027              ; sprite colour registers
multi1          .equ $d025              ; sprite multi colour 1
multi2          .equ $d026              ; sprite multi colour 2
charline12      .equ $05b8              ; row 12 of characer map
charline13      .equ $05e0              ; row 13 of character map
colmapline12    .equ $d9b8              ; row 12 of colour map
colmapline13    .equ $d9e0              ; row 13 of colour map

                .org $c000              ; routine start (49152)

                jsr $e544               ; clear screen

                lda #00                 ; set screen & border colour
                sta $d020
                sta $d021

textinit        ldx #00	                ; init display text
                lda text1, x
                sta charline12, x
                lda text2, x
                sta charline13, x
                inx
                cpx #40
                bne textinit+2

colourinit      ldx #00                 ; init text colours
                lda initcolourmap1, x
                sta colmapline12, x
                lda initcolourmap2, x
                sta colmapline13, x
                inx
                cpx #40
                bne colourinit+2

                lda #255                ; enable all sprites
                sta spriteenable
                sta spritemulti         ; enable multicolour on all

                sei                     ; set up interrupt
                lda #$7f
                sta $dc0d               ; turn off the CIA interrupts
                sta $dd0d
                and $d011               ; clear high bit of raster line
                sta $d011

                ldx #00                 ; setup interrupt queue
                lda intqueuelow, x
                sta $0314
                lda intqueuehigh, x
                sta $0315
                lda inttrigger, x       ; set trigger scan line
                sta $d012
                stx intindex

                lda #$01                ; enable raster interrupts
                sta $d01a
                cli
                rts

spritesplit     inc $d019               ; acknowledge interrupt
                
                ldx intindex
                lda setptrlow, x
                sta $fa
                lda setptrhigh, x
                sta $fb

setpos          ldy #00                 ; set sprite positions
                lda ($fa), y
                sta spritepos, y
                iny
                cpy #16
                bne setpos+2

setcolour       ldx #00                 ; apply sprite colours
                lda ($fa), y
                sta spritecolour, x
                iny
                inx
                cpx #08
                bne setcolour+2

                lda ($fa), y            ; apply sprite multi colours
                sta multi1
                iny
                lda ($fa), y
                sta multi2

                iny
setpointers     ldx #00                 ; set sprite data pointers
                lda ($fa), y
                sta spriteptr, x
                iny
                inx
                cpx #08
                bne setpointers+2

                ldx intindex            ; next interrupt in queue
                inx
                lda intqueuelow, x
                sta $0314
                lda intqueuehigh, x
                sta $0315
                lda inttrigger, x       ; set trigger scan line
                sta $d012
                stx intindex

                jmp $ea81

update          inc $d019               ; acknowledge interrupt
                dec smooth              ; apply smoothing to colour cycle
                bne endupdate
                lda #02
                sta smooth

                lda colourIndex1        ; advance colour indexes for cycling
                adc #01
                and #07
                sta colourIndex1
                lda colourIndex2
                adc #01
                and #07
                sta colourIndex2

cyclerightside	ldx #00                 ; cycle colours on right
                lda colmapline12+21, x
                sta colmapline12+20, x
                lda colmapline13+21, x
                sta colmapline13+20, x
                inx
                cpx #19
                bne cyclerightside+2

cycleleftside   ldx #19                 ; cycle colours on left
                lda colmapline12-1, x
                sta colmapline12, x
                lda colmapline13-1, x
                sta colmapline13, x
                dex
                bne cycleleftside+2

                ldx colourIndex1        ; insert new colour on right
                lda colourtable, x
                sta colmapline12
                sta colmapline12+39

                ldx colourIndex2        ; insert new colour on left
                lda colourtable, x
                sta colmapline13
                sta colmapline13+39

endupdate       ldx #00                 ; reset interrupt queue
                lda intqueuelow, x
                sta $0314
                lda intqueuehigh, x
                sta $0315
                lda inttrigger, x       ; set trigger scan line
                sta $d012
                stx intindex

                jmp $ea81

smooth          .byte 02                                ; colour cycle smoothing
colourIndex1    .byte 00                                ; next colour index row 1
colourIndex2    .byte 01                                ; next colour index row 2
colourtable     .byte 03, 05, 13, 07, 01, 07, 13, 05    ; colour cycle table
initcolourmap1  .byte 03, 05, 13, 07, 01, 07, 13, 05    ; pre calculated colour maps
                .byte 03, 05, 13, 07, 01, 07, 13, 05
                .byte 03, 05, 13, 07, 07, 13, 05, 03
                .byte 05, 13, 07, 01, 07, 13, 05, 03
                .byte 05, 13, 07, 01, 07, 13, 05, 03
initcolourmap2  .byte 05, 13, 07, 01, 07, 13, 05, 03
                .byte 05, 13, 07, 01, 07, 13, 05, 03
                .byte 05, 13, 07, 01, 01, 07, 13, 05
                .byte 03, 05, 13, 07, 01, 07, 13, 05
                .byte 03, 05, 13, 07, 01, 07, 13, 05
text1           .byte 032, 032, 045, 045, 043, 061, 027, 032    ; row 1 text string
                .byte 049, 054, 032, 019, 016, 018, 009, 020
                .byte 005, 032, 045, 032, 018, 001, 019, 020
                .byte 005, 018, 032, 019, 016, 012, 009, 020
                .byte 032, 029, 061, 043, 045, 045, 032, 032
text2           .byte 032, 032, 032, 032, 032, 032, 061, 061    ; row 2 text string
                .byte 061, 061, 061, 032, 032, 032, 023, 023
                .byte 023, 046, 048, 024, 003, 054, 052, 046
                .byte 003, 015, 013, 032, 032, 032, 061, 061
                .byte 061, 061, 061, 032, 032, 032, 032, 032
spriteset1      .byte 089, 050, 113, 060, 137, 070, 161, 080    ; sprite positions (format: x, y)
                .byte 185, 080, 209, 070, 230, 060, 255, 050    
                .byte 02, 04, 06, 08, 08, 06, 04, 02            ; sprite colours
                .byte 10, 15                                    ; multi colours 1 & 2
                .byte $80, $81, $81, $80, $80, $81, $81, $80    ; sprite data pointers
spriteset2      .byte 089, 208, 113, 198, 137, 188, 161, 178    ; sprite positions (format: x, y)
                .byte 185, 178, 209, 188, 230, 198, 255, 208    
                .byte 01, 05, 08, 09, 09, 08, 05, 01            ; sprite colours
                .byte 13, 15                                    ; multi colours 1 & 2
                .byte $81, $81, $80, $81, $81, $80, $81, $81    ; sprite data pointers
intindex        .byte 00
intqueuelow     .byte <spritesplit, <spritesplit, <update       ; interrupt queue
intqueuehigh    .byte >spritesplit, >spritesplit, >update
inttrigger      .byte 000, 140, 250
setptrlow       .byte <spriteset1, <spriteset2
setptrhigh      .byte >spriteset1, >spriteset2
                
                .org $2000                                      ; sprite data location

spritedata      .byte $00, $28, $00, $02, $be, $80, $0b, $d7, $e0, $2d, $69, $78, $2d, $be, $78, $b6
                .byte $d7, $9e, $b7, $69, $de, $b6, $d7, $9e, $b7, $69, $de, $b6, $d7, $9e, $b7, $69
                .byte $de, $b6, $d7, $9e, $2d, $be, $78, $2d, $69, $78, $0b, $d7, $e0, $02, $be, $80
                .byte $00, $28, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $82
                .byte $00, $20, $00, $00, $98, $00, $00, $98, $00, $02, $76, $00, $02, $76, $00, $02
                .byte $66, $00, $09, $dd, $80, $09, $ed, $80, $09, $dd, $80, $09, $dd, $80, $27, $77
                .byte $60, $27, $bb, $60, $27, $bb, $60, $27, $67, $60, $09, $fd, $80, $02, $56, $00
                .byte $00, $a8, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $8b
