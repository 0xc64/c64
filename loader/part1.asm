; -- multi-part loader example - demo part 1 --
;
; Platform: C64
; Code: Jesder / 0xc64
; Site: http://www.0xc64.com
;

                        ; kernal routines

KER_CLRSCREEN           .equ $e544              ; clear screen


                        ; common registers

REG_INTFLAG             .equ $d019              ; interrupt flag register
REG_BORCOLOUR           .equ $d020              ; border colour register
REG_BGCOLOUR            .equ $d021              ; background colour register
REG_KEYBOARD_PORT_A     .equ $dc00
REG_KEYBOARD_PORT_B     .equ $dc01


                        ; constants

C_SCREEN_RAM            .equ $0400
C_UNPACK_ROUTINE        .equ $0810
C_UNPACK_DEST           .equ $0824
C_UNPACK_SOURCE         .equ $0834
C_APPLY_INTERRUPT       .equ $0840
C_EXIT_PART             .equ $084c
C_COLOUR_RAM            .equ $d800


                        ; program start

                        .org $0950


                        ; intro sync ------------------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

sync_intro              inc REG_INTFLAG                 ; acknowledge interrupt

                        jsr KER_CLRSCREEN               ; clear screen

                        lda #000                        ; set border/background
                        sta REG_BORCOLOUR
                        sta REG_BGCOLOUR

                        ldx #039                        ; init messages
render_messages         lda message1, x
                        sta C_SCREEN_RAM + $28, x
                        lda message2, x
                        sta C_SCREEN_RAM + $78, x
                        lda #000
                        sta C_COLOUR_RAM + $28, x
                        sta C_COLOUR_RAM + $78, x
                        dex
                        bpl render_messages

                        lda #049
                        ldx #<render_border_top
                        ldy #>render_border_top
                        jmp C_APPLY_INTERRUPT


                        ; latch raster bar ------------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

latch_raster            dex
                        bpl latch_raster
                        rts


                        ; render single line bar ------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

render_bar              ldx #000                        ; stabalise raster
                        jsr latch_raster                       

                        lda #001                        ; switch on single line border bar
                        sta REG_BORCOLOUR

                        ldx #006                        ; complete raster line
                        jsr latch_raster

                        rts


                        ; render border top -----------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

render_border_top       inc REG_INTFLAG                 ; acknowledge interrupt

                        jsr render_bar

                        lda #000                        ; border bar complete
                        sta REG_BORCOLOUR

                        lda #250
                        ldx #<render_border_bot
                        ldy #>render_border_bot
                        jmp C_APPLY_INTERRUPT


                        ; render border bottom --------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

render_border_bot       inc REG_INTFLAG                 ; acknowledge interrupt

                        jsr render_bar

                        lda #006                        ; border bar complete
                        sta REG_BORCOLOUR

                        lda #255
                        ldx #<update_colours
                        ldy #>update_colours
                        jmp C_APPLY_INTERRUPT


                        ; update colours --------------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

update_colours          inc REG_INTFLAG                 ; acknowledge interrupt

                        lda #$7f                        ; detect space bar
                        sta REG_KEYBOARD_PORT_A
                        lda REG_KEYBOARD_PORT_B
                        and #$10
                        bne update_colour_ram

                        jmp C_EXIT_PART

update_colour_ram       dec colour_advance_delay        ; smooth colour cycle
                        bpl update_colours_done
                        lda #001
                        sta colour_advance_delay

                        ldx #038                        ; shift colour ram right
shift_cols_right        lda C_COLOUR_RAM + $28, x
                        sta C_COLOUR_RAM + $29, x
                        dex
                        bpl shift_cols_right

                        ldx #000                        ; shift colour ram left
shift_cols_left         lda C_COLOUR_RAM + $79, x
                        sta C_COLOUR_RAM + $78, x
                        inx
                        cpx #039
                        bne shift_cols_left

                        ldx colour_index                ; grab next colour in sequence
                        lda colour_sequence, x
                        sta C_COLOUR_RAM + $28          ; insert new colour into ram
                        sta C_COLOUR_RAM + $9f                        
                        inx                             ; advance colour index
                        txa
                        and #015                        ; loop back to 0
                        sta colour_index

update_colours_done     lda #049
                        ldx #<render_border_top
                        ldy #>render_border_top
                        jmp C_APPLY_INTERRUPT


                        ; data tables -----------------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

message1                .byte 032, 032, 032, 032, 032, 032, 019, 009, 013, 016, 012, 005, 032, 012, 015, 001
                        .byte 004, 005, 018, 032, 005, 024, 001, 013, 016, 012, 005, 032, 045, 032, 048, 024
                        .byte 003, 054, 052, 032, 032, 032, 032, 032
message2                .byte 032, 032, 032, 032, 032, 032, 032, 032, 032, 016, 018, 005, 019, 019, 032, 019
                        .byte 016, 001, 003, 005, 032, 020, 015, 032, 003, 015, 014, 020, 009, 014, 021, 005
                        .byte 032, 032, 032, 032, 032, 032, 032, 032
colour_advance_delay    .byte 001
colour_index            .byte 000
colour_sequence         .byte 009, 008, 005, 013, 013, 005, 008, 009, 002, 010, 007, 001, 007, 010, 002, 009