; -- music player --
;
; Platform: C64
; Code: Jesder / 0xc64
; Site: http://www.0xc64.com
;


                        ; common register definitions

REG_INTSERVICE_LOW      .equ $0314              ; interrupt service routine low byte
REG_INTSERVICE_HIGH     .equ $0315              ; interrupt service routine high byte
REG_SCREENCTL_1         .equ $d011              ; screen control register #1
REG_RASTERLINE          .equ $d012              ; raster line position 
REG_INTFLAG             .equ $d019              ; interrupt flag register
REG_INTCONTROL          .equ $d01a              ; interrupt control register
REG_BORCOLOUR           .equ $d020              ; border colour register
REG_BGCOLOUR            .equ $d021              ; background colour register
REG_INTSTATUS_1         .equ $dc0d              ; interrupt control and status register #1
REG_INTSTATUS_2         .equ $dd0d              ; interrupt control and status register #2


                        ; constants

C_MUSIC_LOCATION        .equ $c000
C_MUSIC_INIT            .equ $c048
C_MUSIC_PLAY            .equ $c021


                        ; program start

                        .org $0801              ; begin (2049)

                        .byte $0b, $08, $01, $00, $9e, $32, $30, $36
                        .byte $31, $00, $00, $00 ;= SYS 2061


                        ; relocate music

                        ldx #00
music_relocate          lda music_data, x
                        sta C_MUSIC_LOCATION, x
                        lda music_data + $100, x
                        sta C_MUSIC_LOCATION + $100, x
                        lda music_data + $200, x
                        sta C_MUSIC_LOCATION + $200, x
                        lda music_data + $300, x
                        sta C_MUSIC_LOCATION + $300, x
                        lda music_data + $400, x
                        sta C_MUSIC_LOCATION + $400, x
                        lda music_data + $500, x
                        sta C_MUSIC_LOCATION + $500, x
                        lda music_data + $600, x
                        sta C_MUSIC_LOCATION + $600, x
                        lda music_data + $700, x
                        sta C_MUSIC_LOCATION + $700, x
                        lda music_data + $800, x
                        sta C_MUSIC_LOCATION + $800, x
                        lda music_data + $900, x
                        sta C_MUSIC_LOCATION + $900, x
                        lda music_data + $a00, x
                        sta C_MUSIC_LOCATION + $a00, x
                        lda music_data + $b00, x
                        sta C_MUSIC_LOCATION + $b00, x
                        lda music_data + $b5d, x
                        sta C_MUSIC_LOCATION + $b5d, x
                        inx
                        bne music_relocate


                        ; initialise screen

                        lda #00
                        sta REG_BORCOLOUR
                        sta REG_BGCOLOUR


                        ; initialise music

                        ldx #00
                        ldy #00
                        jsr C_MUSIC_INIT


                        ; update loop interrupt

                        sei                     ; set up interrupt
                        lda #$7f
                        sta REG_INTSTATUS_1     ; turn off the CIA interrupts
                        sta REG_INTSTATUS_2
                        and REG_SCREENCTL_1     ; clear high bit of raster line
                        sta REG_SCREENCTL_1

                        ldy #40
                        sty REG_RASTERLINE

                        lda #<update_loop       ; load interrupt address
                        ldx #>update_loop
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        lda #$01                ; enable raster interrupts
                        sta REG_INTCONTROL
                        cli


                        ; forever loop

forever                 jmp forever

                        
                        ; update 

update_loop             inc REG_INTFLAG         ; acknowledge interrupt

                        lda #01
                        sta REG_BORCOLOUR

                        jsr C_MUSIC_PLAY

                        lda #00
                        sta REG_BORCOLOUR
    
                        jmp $ea81



                        ; music data - 3165 bytes

music_data              ; music data removed for release
