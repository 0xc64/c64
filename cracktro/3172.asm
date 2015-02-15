; -- 3172 intro --
;
; Platform: C64
; Code: Jesder / 0xc64
; Logo: JSL
; Music: Trident (Short.sid)
; About: A small cracktro style intro for the c64
; Site: http://www.0xc64.com
;

                        ; zero page registers

REG_ZERO_02             .equ $02
REG_ZERO_03             .equ $03
REG_ZERO_04             .equ $04
REG_ZERO_2A             .equ $2a
REG_ZERO_52             .equ $52
REG_ZERO_FB             .equ $fb                ; reserve for music player
REG_ZERO_FC             .equ $fc                ; reserve for music player
REG_ZERO_FD             .equ $fd                ; reserve for music player
REG_ZERO_FE             .equ $fe                ; reserve for music player


                        ; common register definitions

REG_INTSERVICE_LOW      .equ $0314              ; interrupt service routine low byte
REG_INTSERVICE_HIGH     .equ $0315              ; interrupt service routine high byte
REG_SPRITE_DATA_PTR_0   .equ $07f8              ; sprite data pointer address start
REG_SPRITE_X_0          .equ $d000              ; sprite 0 x position
REG_SPRITE_Y_0          .equ $d001              ; sprite 0 y position
REG_SPRITE_X_1          .equ $d002              ; sprite 1 x position
REG_SPRITE_Y_1          .equ $d003              ; sprite 1 y position
REG_SPRITE_X_2          .equ $d004              ; sprite 2 x position
REG_SPRITE_Y_2          .equ $d005              ; sprite 2 y position
REG_SPRITE_X_3          .equ $d006              ; sprite 3 x position
REG_SPRITE_Y_3          .equ $d007              ; sprite 3 y position
REG_SPRITE_X_4          .equ $d008              ; sprite 4 x position
REG_SPRITE_Y_4          .equ $d009              ; sprite 4 y position
REG_SPRITE_X_5          .equ $d00a              ; sprite 5 x position
REG_SPRITE_Y_5          .equ $d00b              ; sprite 5 y position
REG_SPRITE_X_6          .equ $d00c              ; sprite 6 x position
REG_SPRITE_Y_6          .equ $d00d              ; sprite 6 y position
REG_SPRITE_X_7          .equ $d00e              ; sprite 7 x position
REG_SPRITE_Y_7          .equ $d00f              ; sprite 7 y position
REG_SPRITE_X_MSB        .equ $d010              ; sprite 0-7 X position bit 8
REG_SCREENCTL_1         .equ $d011              ; screen control register #1
REG_RASTERLINE          .equ $d012              ; raster line position 
REG_SPRITE_ENABLE       .equ $d015              ; enable sprites
REG_SCREENCTL_2         .equ $d016              ; screen control register #2
REG_MEMSETUP            .equ $d018              ; memory setup register
REG_INTFLAG             .equ $d019              ; interrupt flag register
REG_INTCONTROL          .equ $d01a              ; interrupt control register
REG_SPRITE_MULTICOLOUR  .equ $d01c              ; sprite multicolour enable
REG_SPRITE_D_WIDTH      .equ $d01d              ; double width sprites
REG_BORCOLOUR           .equ $d020              ; border colour register
REG_BGCOLOUR            .equ $d021              ; background colour register
REG_SPRITE_MC_1         .equ $d025              ; extra sprite colour 1
REG_SPRITE_MC_2         .equ $d026              ; extra sprite colour 2
REG_SPRITE_COLOUR_0     .equ $d027              ; sprite 0 colour
REG_SPRITE_COLOUR_1     .equ $d028              ; sprite 1 colour
REG_SPRITE_COLOUR_2     .equ $d029              ; sprite 2 colour
REG_SPRITE_COLOUR_3     .equ $d02a              ; sprite 3 colour
REG_SPRITE_COLOUR_4     .equ $d02b              ; sprite 4 colour
REG_SPRITE_COLOUR_5     .equ $d02c              ; sprite 5 colour
REG_SPRITE_COLOUR_6     .equ $d02d              ; sprite 6 colour
REG_SPRITE_COLOUR_7     .equ $d02e              ; sprite 7 colour
REG_INTSTATUS_1         .equ $dc0d              ; interrupt control and status register #1
REG_INTSTATUS_2         .equ $dd0d              ; interrupt control and status register #2


                        ; constants

C_SCREEN_BANK_0         .equ $0400              ; screen RAM
C_DYCP_HIGH_ROW         .equ $05b8              ; screen RAM - dycp row 1
C_DYCP_LOW_ROW          .equ $05e0              ; screen RAM - dycp row 2
C_SPRITE_PTRS_BANK_3    .equ $07f8              ; location of sprite pointers in bank 3
C_MUSIC_LOCATION        .equ $1000              ; location of music
C_MUSIC_INIT            .equ $1000              ; music init routine
C_MUSIC_PLAY            .equ $1003              ; music player routine
C_SPRITES_BANK_3        .equ $2000              ; start of sprite data location
C_CHARSET               .equ $3000              ; storage for character set
C_SCREEN_RAM_BANK_2     .equ $4400              ; screen memory in VIC bank 2
C_SPRITE_PTRS_BANK_2    .equ $47f8              ; location of sprite pointers in bank 2
C_SPRITES_BANK_2        .equ $6000              ; storage for sprites in VIC bank 2
C_INFLATE_CACHE         .equ $6d00              ; storage for data inflation at startup
C_TEMPORARY_DATA        .equ $c000
C_SCROLLER_BAR_COLOURS  .equ $c000              ; scroller raster bar colours
C_SCROLL_TRANS_INDEX    .equ $c0d0              ; scroller transition in step index
C_TEXT_GLOW_SEQUENCE    .equ $c0e0              ; credit text colout sequence
C_ANIM_BAR_TABLE        .equ $c100              ; animated raster bar render target
C_ANIM_SCROLL_TABLE     .equ $c120              ; animates raster bar scroll offset table
C_ANIM_BAR_COLOURS      .equ $c140              ; colours used in animated raster bars
C_ANIM_BAR_TRAN_INDEX   .equ $c200              ; transition in index for animated raster bars
C_SCROLL_SINE_INDEX     .equ $c201              ; scroller height sine index
C_SCROLL_MESSAGE_INDEX  .equ $c202              ; scroller character index
C_TEXT_WAVE_SINE_INDEX  .equ $c203              ; text wave sine index
C_SPRITE_SPLIT_INDEX    .equ $c205              ; intro transition sprite split index (1 byte)
C_INTRO_CLEAR_COUNTER   .equ $c206              ; intro transition sprite row counter (1 byte)
C_SPLIT_INDEX           .equ $c207              ; final intro transition split index (1 byte)
C_SPLIT_SEQUENCE_INDEX  .equ $c208              ; final intro transition seq index (7 bytes)
C_SPLIT_SEQUENCE_ACTIVE .equ $c20f              ; final intro transition active seq index (7 bytes)
C_SMOOTHING_1           .equ $c217              ; smoothing counter (1 byte)
C_SCROLL_BUFFER_LOW     .equ $c240              ; scroller source char low byte table (40 bytes)
C_SCROLL_BUFFER_HIGH    .equ $c280              ; scroller source char high byte table (40 bytes)
C_SCROLL_BUFFER_HEIGHT  .equ $c2d2              ; scroller height table (40 bytes)
C_LOGO_COLOURS          .equ $c300              ; logo colour table
C_LOGO_COL_INDEX_1      .equ $c340              ; first logo colour index
C_LOGO_COL_INDEX_2      .equ $c341              ; second logo colour index
C_LOGO_TRANS_STEP       .equ $c342              ; logo transition step (0 - 2)
C_LOGO_TRANS_ACTIVE     .equ $c343              ; logo transition is active
C_LOGO_TRANS_DELAY      .equ $c344              ; delay between logo transitions
C_SCROLLER_ACTIVE       .equ $c345              ; text scroller active
C_TEXT_BARS_ACTIVE      .equ $c346              ; animated text bars active
C_SCROLL_MESSAGE        .equ $c400              ; scroller message
C_COLOUR_RAM            .equ $d800              ; colour ram


                        ; program start

                        .org $8000               ; begin (32768)


                        ; create initial interrupt

                        sei                     ; set up interrupt
                        lda #$7f
                        sta REG_INTSTATUS_1     ; turn off the CIA interrupts
                        sta REG_INTSTATUS_2
                        and REG_SCREENCTL_1     ; clear high bit of raster line
                        sta REG_SCREENCTL_1

                        ldy #000
                        sty REG_RASTERLINE

                        lda #<sync_intro        ; load interrupt address
                        ldx #>sync_intro
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        lda #$01                ; enable raster interrupts
                        sta REG_INTCONTROL
                        cli


                        ; forever loop

forever                 jmp forever


                        ; intro sync ------------------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

sync_intro              inc REG_INTFLAG                 ; acknowledge interrupt

                        ldx #000                        ; clear table cache & VIC bank 2 screen ram
init_table_data         lda #000
                        sta C_TEMPORARY_DATA, x         
                        sta C_TEMPORARY_DATA + $100, x
                        sta C_TEMPORARY_DATA + $200, x
                        sta C_TEMPORARY_DATA + $300, x
                        lda #032
                        sta C_SCREEN_RAM_BANK_2, x      
                        sta C_SCREEN_RAM_BANK_2 + $100, x
                        sta C_SCREEN_RAM_BANK_2 + $200, x
                        sta C_SCREEN_RAM_BANK_2 + $300, x
                        inx
                        bne init_table_data

                        ldx #063                        ; init intro transition sprite memory
                        lda #000
clear_sprite_memory     sta C_SPRITES_BANK_3, x
                        dex
                        bpl clear_sprite_memory

                        lda #127                        
                        sta REG_SPRITE_ENABLE           ; enable sprites 0-6
                        sta REG_SPRITE_D_WIDTH          ; set double width sprites

                        lda #096                        ; sprites 5 & 6 > 255 for intro transition
                        sta REG_SPRITE_X_MSB

                        ldx #006                        ; init sprite x positions
init_clear_sprites      lda clear_screen_sprite_x, x
write_clean_sprite_x    sta REG_SPRITE_X_6
                        dec write_clean_sprite_x + 1
                        dec write_clean_sprite_x + 1
                        dex
                        bpl init_clear_sprites

                        ldx #006                        ; init intro sprite data pointers
init_sprite_pointers    lda #128
                        sta REG_SPRITE_DATA_PTR_0, x
                        lda REG_BORCOLOUR
                        sta REG_SPRITE_COLOUR_0, x
                        dex
                        bpl init_sprite_pointers

                        ldx #000                        ; relocate font and sprites
relocate_font_n_sprites lda C_INFLATE_CACHE, x
                        sta C_CHARSET, x
                        lda C_INFLATE_CACHE + $100, x
                        sta C_CHARSET + $100, x
                        lda C_INFLATE_CACHE + $200, x
                        sta C_SPRITES_BANK_3 + $40, x
                        lda C_INFLATE_CACHE + $300, x
                        sta C_SPRITES_BANK_3 + $140, x
                        lda C_INFLATE_CACHE + $400, x
                        sta C_SPRITES_BANK_2 + $40, x
                        lda C_INFLATE_CACHE + $500, x
                        sta C_SPRITES_BANK_2 + $140, x
                        inx
                        bne relocate_font_n_sprites

                        ldx #000                        ; relocate music
relocate_music          lda C_INFLATE_CACHE + $600, x
                        sta C_MUSIC_LOCATION, x
                        lda C_INFLATE_CACHE + $700, x
                        sta C_MUSIC_LOCATION + $100, x
                        lda C_INFLATE_CACHE + $800, x
                        sta C_MUSIC_LOCATION + $200, x
                        lda C_INFLATE_CACHE + $900, x
                        sta C_MUSIC_LOCATION + $300, x

                        lda C_INFLATE_CACHE + $a00, x
                        sta C_MUSIC_LOCATION + $400, x
                        lda C_INFLATE_CACHE + $b00, x
                        sta C_MUSIC_LOCATION + $500, x
                        lda C_INFLATE_CACHE + $c00, x
                        sta C_MUSIC_LOCATION + $600, x
                        lda C_INFLATE_CACHE + $d00, x
                        sta C_MUSIC_LOCATION + $700, x

                        lda C_INFLATE_CACHE + $e00, x
                        sta C_MUSIC_LOCATION + $800, x
                        inx
                        bne relocate_music

                        ldx #000                        ; relocate scroller message
relocate_scroll_message lda C_INFLATE_CACHE + $ef9, x
                        sta C_SCROLL_MESSAGE, x
                        lda C_INFLATE_CACHE + $fc7, x
                        sta C_SCROLL_MESSAGE + 206, x
                        lda C_INFLATE_CACHE + $1095, x
                        sta C_SCROLL_MESSAGE + 412, x
                        lda C_INFLATE_CACHE + $1163, x
                        sta C_SCROLL_MESSAGE + 618, x
                        inx
                        cpx #206
                        bne relocate_scroll_message

                        ldx #041                        ; relocate logo colour table
relocate_logo_colours   lda logo_colour_sequences, x
                        sta C_LOGO_COLOURS, x
                        dex
                        bpl relocate_logo_colours

                        ldx #011                        ; relocate colour cycle table
relocate_text_glow_cols lda colour_glow_sequence, x
                        sta C_TEXT_GLOW_SEQUENCE, x
                        dex
                        bpl relocate_text_glow_cols

                        ldx #023                                ; relocate scroller raster colours
relocate_scroll_colours lda scroller_bar_colours, x             ; first 14 bytes already defined as 0
                        sta C_SCROLLER_BAR_COLOURS + 14, x
                        dex
                        bpl relocate_scroll_colours

                        ldx #039                        ; initialise dycp scroll buffer low/high memory bytes
init_scroll_buffer      lda #$00
                        sta C_SCROLL_BUFFER_LOW, x
                        sta C_SCROLL_BUFFER_HEIGHT, x
                        lda #$31
                        sta C_SCROLL_BUFFER_HIGH, x
                        dex
                        bpl init_scroll_buffer

                        clc                             ; generate inverse font characters
                        ldx #000
generate_inverse_font   lda C_CHARSET, x
                        sta REG_ZERO_52
                        lda #$ff
                        sbc REG_ZERO_52
                        sta C_CHARSET + $200, x
                        lda C_CHARSET + $100, x
                        sta REG_ZERO_52
                        lda #$ff
                        sbc REG_ZERO_52
                        sta C_CHARSET + $300, x
                        inx
                        bne generate_inverse_font

                        ldx #000                        ; clear upper characters for dycp scoller chars
                        lda #000
clear_higher_charset    sta C_CHARSET + $400, x
                        sta C_CHARSET + $500, x
                        sta C_CHARSET + $600, x
                        inx
                        bne clear_higher_charset

                        ldx #007                        ; bank 2 space char (32) needs to be cleared
                        lda #000
clean_bank2_font_crap   sta C_INFLATE_CACHE + $400, x
                        dex
                        bpl clean_bank2_font_crap

                        ldx #000                        ; initialise music
                        ldy #000
                        jsr C_MUSIC_INIT                        

                        ldy #029                        ; intro time - away we go
                        sty REG_RASTERLINE
                        lda #<update_music
                        ldx #>update_music
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        jmp $ea81


                        ; music update ----------------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

update_music            inc REG_INTFLAG                 ; acknowledge interrupt

                        jsr C_MUSIC_PLAY                ; update music

set_postmusic_line      ldy #048
                        sty REG_RASTERLINE
set_postmusic_low       lda #<intro_sprite_splits
set_postmusic_high      ldy #>intro_sprite_splits
                        sta REG_INTSERVICE_LOW
                        sty REG_INTSERVICE_HIGH

                        jmp $ea81



                        ; #################################################################################################################]
                        ; ####
                        ; #### Intro section routines - sprite splits, fade to black
                        ; ####
                        ; #################################################################################################################]

                        ; intro sprite splits ---------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

intro_sprite_splits     inc REG_INTFLAG                 ; acknowledge interrupt
                        
                        ldx C_SPRITE_SPLIT_INDEX        ; grab sprite split index
                        bne advance_split_y
                        lda #050                        ; reset sprites on first split
                        jmp set_sprite_pos
advance_split_y         clc
                        lda REG_SPRITE_Y_0              ; advance 21 lines on subsequent splits 
                        adc #021

set_sprite_pos          sta REG_SPRITE_Y_0              ; set sprite positions
                        sta REG_SPRITE_Y_1
                        sta REG_SPRITE_Y_2
                        sta REG_SPRITE_Y_3
                        sta REG_SPRITE_Y_4
                        sta REG_SPRITE_Y_5
                        sta REG_SPRITE_Y_6

                        inx                             ; advance split index
                        cpx #010                        ; detect last required split reached
                        bcs intro_sprite_split_done

                        adc #019                        ; advance next split raster line
                        sta REG_RASTERLINE

                        jmp sprite_split_complete

intro_sprite_split_done ldy #248                        ; all sprite splits performed
                        sty REG_RASTERLINE
post_introsplit_low     lda #<update_intro_clear
post_introsplit_high    ldx #>update_intro_clear
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        ldx #000                        ; reset split index for next update
sprite_split_complete   stx C_SPRITE_SPLIT_INDEX

                        jmp $ea81


                        ; basic to demo transition effect ---------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

update_intro_clear      inc REG_INTFLAG                 ; acknowledge interrupt

                        dec clear_smoothing             ; apply smoothing
                        bpl intro_update_complete
                        lda #002
                        sta clear_smoothing

                        ldy #002                        ; fill next row of sprite data
                        ldx C_INTRO_CLEAR_COUNTER
                        lda #255
write_sprite_byte       sta C_SPRITES_BANK_3, x
advance_sprite_offset   inx                             ; 3 bytes per row
                        dey
                        bpl write_sprite_byte

intro_adv1              inx                             ; skip every second row, catch them on the rebound
intro_adv2              inx
intro_adv3              inx
                        stx C_INTRO_CLEAR_COUNTER
                        bmi intro_transition_done       ; detect transition complete

                        cpx #063                        ; detect half complete
                        bcc intro_update_complete

                        lda #059                        ; set up rebound
                        sta C_INTRO_CLEAR_COUNTER

                        lda #$ca                        ; swap inx for dex op code
                        sta advance_sprite_offset
                        sta intro_adv1
                        sta intro_adv2
                        sta intro_adv3
                        jmp intro_update_complete

intro_transition_done   lda #241                        ; set up fade to black effect
                        sta intro_sprite_split_done + 1
                        lda #<init_fade_to_black
                        sta post_introsplit_low + 1
                        lda #>init_fade_to_black
                        sta post_introsplit_high + 1

intro_update_complete   ldy #029
                        sty REG_RASTERLINE
                        lda #<update_music
                        ldx #>update_music
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        jmp $ea31


                        ; initialise effect -----------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

init_fade_to_black      inc REG_INTFLAG

                        lda REG_BORCOLOUR               ; sync background colour
                        sta REG_BGCOLOUR

                        lda #032                        ; clear screen ram
                        ldx #127
clear_screen_loop       sta C_SCREEN_BANK_0, x    
                        sta C_SCREEN_BANK_0 + $80, x
                        sta C_SCREEN_BANK_0 + $100, x
                        sta C_SCREEN_BANK_0 + $180, x
                        sta C_SCREEN_BANK_0 + $200, x
                        sta C_SCREEN_BANK_0 + $280, x
                        sta C_SCREEN_BANK_0 + $300, x
                        sta C_SCREEN_BANK_0 + $368, x
                        dex
                        bpl clear_screen_loop

                        lda #000
                        sta REG_SPRITE_ENABLE           ; disable all sprites
                        sta REG_SPRITE_D_WIDTH          ; switch off double width

                        lda split_raster_rows + 1       ; init post music update interrupt
                        sta set_postmusic_line + 1

                        lda #<fade_split
                        sta set_postmusic_low + 1
                        lda #>fade_split
                        sta set_postmusic_high + 1

                        ldy #029
                        sty REG_RASTERLINE
                        lda #<update_music
                        ldx #>update_music
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        jmp $ea81


                        ; fade raster split -----------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

fade_split              inc REG_INTFLAG

                        nop                             ; stabalise raster

                        ldx C_SPLIT_INDEX               ; set border / bg colour
                        ldy C_SPLIT_SEQUENCE_INDEX, x
                        lda fade_colour_sequence, y
                        sta REG_BORCOLOUR
                        sta REG_BGCOLOUR

                        inx                             ; advance split index

                        cpx #001                        ; run music update between first and second splits
                        bne test_final_fade_split

                        ldy #029
                        sty REG_RASTERLINE
                        lda #<update_music
                        ldy #>update_music
                        sta REG_INTSERVICE_LOW
                        sty REG_INTSERVICE_HIGH

                        jmp fade_split_complete

test_final_fade_split   cpx #007                        ; run update routine between split loop
                        bcc next_fade_split
                        ldx #000

                        ldy #253
                        sty REG_RASTERLINE
                        lda #<intro_fade_update
                        ldy #>intro_fade_update
                        sta REG_INTSERVICE_LOW
                        sty REG_INTSERVICE_HIGH

                        jmp fade_split_complete

next_fade_split         lda split_raster_rows, x
                        sta REG_RASTERLINE

fade_split_complete     stx C_SPLIT_INDEX

                        jmp $ea81


                        ; fade to black update --------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

intro_fade_update       inc REG_INTFLAG

                        dec fade_smoothing              ; apply smoothing to fade
                        bpl fade_update_complete
                        lda #01
                        sta fade_smoothing

                        ldx #006                                
activate_fadetoblack    dec intro_fade_delay_table, x
                        bpl update_active_sequence      ; activate sequence
                        lda #001
                        sta C_SPLIT_SEQUENCE_ACTIVE, x
                        jmp advance_fade_index

update_active_sequence  lda C_SPLIT_SEQUENCE_ACTIVE, x
                        beq continue_fade_update
                        
advance_fade_index      clc
                        lda C_SPLIT_SEQUENCE_INDEX, x   ; advance index on active sequence
                        adc #001
                        cmp #009
                        bcs continue_fade_update
                        sta C_SPLIT_SEQUENCE_INDEX, x

continue_fade_update    dex
                        bpl activate_fadetoblack

                        lda C_SPLIT_SEQUENCE_INDEX + 3  ; detect all slices faded to black
                        cmp #008
                        bcc fade_update_complete

                        lda #251                        ; introduce logo rendering
                        sta set_postmusic_line + 1
                        lda #<setup_intro_mainpart
                        sta set_postmusic_low + 1
                        lda #>setup_intro_mainpart
                        sta set_postmusic_high + 1

fade_update_complete    ldy #000
                        sty REG_RASTERLINE
                        lda #<fade_split
                        ldx #>fade_split
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        jmp $ea81



                        ; #################################################################################################################]
                        ; ####
                        ; #### Main demo - 2x 8x2 sprite logos, raster bars, colour cycling, dycp scroller
                        ; ####
                        ; #################################################################################################################]


                        ; setup main demo part --------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

setup_intro_mainpart    inc REG_INTFLAG                 ; acknowledge interrupt
                        
                        ldx #036                        ; initialise logo transition variables
                        stx C_LOGO_COL_INDEX_1
                        ldx #045
                        stx C_LOGO_COL_INDEX_2
                        lda #005
                        sta C_LOGO_TRANS_DELAY

                        lda #000                        ; reset sprite & multi colours to black
                        ldx #009
reset_sprite_colours    sta REG_SPRITE_MC_1, x
                        dex
                        bpl reset_sprite_colours

                        lda #255                        ; enable all sprites
                        sta REG_SPRITE_ENABLE

                        lda #255                        ; enable multi colour sprites
                        sta REG_SPRITE_MULTICOLOUR

                        clc                             ; initialise logo sprite data pointers
                        ldx #000
                        lda #129
init_logo_sprite_ptrs   sta C_SPRITE_PTRS_BANK_3, x
                        sta C_SPRITE_PTRS_BANK_2, x
                        adc #001
                        inx
                        cpx #008
                        bcc init_logo_sprite_ptrs

                        lda #047                        ; introduce logo rendering
                        sta set_postmusic_line + 1
                        lda #<logo_split_toprow
                        sta set_postmusic_low + 1
                        lda #>logo_split_toprow
                        sta set_postmusic_high + 1

                        lda #028                        ; switch to demo font
                        sta REG_MEMSETUP

                        ldx #011                        ; plot text for credits
plot_credits_text       lda credits_code, x
                        sta C_SCREEN_BANK_0 + $f5, x
                        lda credits_logo, x
                        sta C_SCREEN_BANK_0 + $108, x
                        lda credits_music, x
                        sta C_SCREEN_BANK_0 + $14e, x
                        lda #000                        ; init colour ram to black
                        sta C_COLOUR_RAM + $f5, x
                        sta C_COLOUR_RAM + $108, x
                        sta C_COLOUR_RAM + $14e, x
                        dex
                        bpl plot_credits_text

                        ldx #039                        ; plot text for greets
plot_greets_text        lda display_text_a, x
                        sta C_SCREEN_BANK_0 + $280, x
                        lda display_text_b, x
                        sta C_SCREEN_BANK_0 + $2a8, x
                        lda display_text_c, x
                        sta C_SCREEN_BANK_0 + $2d0, x
                        lda #000                        ; set colour ram to black
                        sta C_COLOUR_RAM + $280, x
                        sta C_COLOUR_RAM + $2a8, x
                        sta C_COLOUR_RAM + $2d0, x
                        dex
                        bpl plot_greets_text

                        clc
                        ldx #000
                        lda #127                        ; initialise dycp scroll area with correct chars
clear_scroller_area     adc #001
                        sta C_DYCP_HIGH_ROW, x
                        adc #001
                        sta C_DYCP_LOW_ROW, x
                        inx
                        cpx #040
                        bne clear_scroller_area

                        ldy #029
                        sty REG_RASTERLINE
                        lda #<update_music
                        ldx #>update_music
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        jmp $ea81


                        ; logo split ------------------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

logo_split_toprow       inc REG_INTFLAG                 ; acknowledge interrupt
                
                        ldy logo_index                  ; which logo are we rendering?

                        lda C_LOGO_COL_INDEX_1, y       ; grab colour table index
                        tax

                        lda C_LOGO_COLOURS, x           ; apply multi colour 1
                        sta REG_SPRITE_MC_1

                        lda C_LOGO_COLOURS + 2, x       ; apply multu colour 2
                        sta REG_SPRITE_MC_2

                        lda C_LOGO_COLOURS + 1, x       ; apply sprite colours
                        sta REG_SPRITE_COLOUR_0
                        sta REG_SPRITE_COLOUR_1
                        sta REG_SPRITE_COLOUR_2
                        sta REG_SPRITE_COLOUR_3
                        sta REG_SPRITE_COLOUR_4
                        sta REG_SPRITE_COLOUR_5
                        sta REG_SPRITE_COLOUR_6
                        sta REG_SPRITE_COLOUR_7

                        clc
                        lda logo_sine_offset, y         ; apply x position of sprites
                        tax
                        lda logo_sine_table, x
                        asl

                        ldx #000                        ; use x register to flag sprites > 255
                        adc #033
                        sta REG_SPRITE_X_0
                        adc #024
                        sta REG_SPRITE_X_1
                        adc #024
                        sta REG_SPRITE_X_2
                        adc #024
                        sta REG_SPRITE_X_3
                        adc #024
                        sta REG_SPRITE_X_4
                        adc #024
                        bcc set_logo_spr_5
                        ldx #224
                        clc
set_logo_spr_5          sta REG_SPRITE_X_5
                        adc #024
                        bcc set_logo_spr_6
                        ldx #192
                        clc
set_logo_spr_6          sta REG_SPRITE_X_6
                        adc #024
                        sta REG_SPRITE_X_7
                        bcc set_msb
                        ldx #128

set_msb                 stx REG_SPRITE_X_MSB            ; set msb for sprites

                        lda logo_y_pos, y               ; apply y position of sprites i logo
                        sta REG_SPRITE_Y_0
                        sta REG_SPRITE_Y_1
                        sta REG_SPRITE_Y_2
                        sta REG_SPRITE_Y_3
                        sta REG_SPRITE_Y_4
                        sta REG_SPRITE_Y_5
                        sta REG_SPRITE_Y_6
                        sta REG_SPRITE_Y_7

                        lda $dd00                       ; set VIC bank to 3
                        and #252
                        ora #003
                        sta $dd00

                        cpy #000
                        bne logo_split_toprow_done

                        lda C_TEXT_BARS_ACTIVE
                        beq logo_split_toprow_done

                        dec glow_smoothing
                        bne logo_split_toprow_done

                        ldx #009                        ; apply colour cycle
cycle_colours_a         lda C_COLOUR_RAM + $f5, x
                        sta C_COLOUR_RAM + $f6, x
                        lda C_COLOUR_RAM + $154, x
                        sta C_COLOUR_RAM + $155, x
                        dex
                        bpl cycle_colours_a

                        ldx colour_glow_indexs          ; insert next code colour
                        lda C_TEXT_GLOW_SEQUENCE, x
                        sta $d8f5

                        inx                             ; advance code cycle index
                        txa
                        and #031
                        sta colour_glow_indexs

logo_split_toprow_done  lda logo_split_top_row, y       ; next interrupt before sprites completely drawn
                        sta REG_RASTERLINE
                        lda #<logo_split_bottomrow
                        ldx #>logo_split_bottomrow
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        jmp $ea81


logo_split_bottomrow    inc REG_INTFLAG                 ; acknowledge interrupt

                        clc
                        lda REG_SPRITE_Y_0              ; grab current y value
                        adc #021                        ; position sprites directly below first row
                        sta REG_SPRITE_Y_0
                        sta REG_SPRITE_Y_1
                        sta REG_SPRITE_Y_2
                        sta REG_SPRITE_Y_3
                        sta REG_SPRITE_Y_4
                        sta REG_SPRITE_Y_5
                        sta REG_SPRITE_Y_6
                        sta REG_SPRITE_Y_7

                        ldy logo_index                  ; next interrupt just before second row to render
                        lda logo_split_bot_row, y
                        sta REG_RASTERLINE
                        lda #<logo_split_swapbank
                        ldx #>logo_split_swapbank
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH
    
                        jmp $ea81


logo_split_swapbank     inc REG_INTFLAG                 ; acknowledge interrupt

                        lda $dd00                       ; switch to bank 2
                        and #252
                        ora #002
                        sta $dd00

                        lda glow_smoothing
                        bne update_scroller_buffer

update_text_col_cycle   lda #002
                        sta glow_smoothing

                        ldx #00
cycle_colours_b         lda C_COLOUR_RAM + $109, x
                        sta C_COLOUR_RAM + $108, x
                        lda C_COLOUR_RAM + $149, x
                        sta C_COLOUR_RAM + $148, x
                        inx
                        cpx #011
                        bcc cycle_colours_b

                        ldx colour_glow_indexs + 1      ; insert next art credit colour
                        lda C_TEXT_GLOW_SEQUENCE, x
                        sta C_COLOUR_RAM + $113

                        inx                             ; advance art credit cycle index
                        txa
                        and #031
                        sta colour_glow_indexs + 1

                        ldx colour_glow_indexs + 2      ; insert next music credit colour
                        lda C_TEXT_GLOW_SEQUENCE, x
                        sta C_COLOUR_RAM + $154
                        sta C_COLOUR_RAM + $153

                        inx                             ; advance music credit cycle index
                        txa
                        and #031
                        sta colour_glow_indexs + 2
                        jmp detect_logos_rendered

update_scroller_buffer  ldy logo_index                  ; only process during second logo rendering
                        beq detect_logos_rendered

                        ldy C_SCROLLER_ACTIVE
                        beq detect_logos_rendered

                        dec scroll_magnitude            ; update hardware scroll size
                        bpl scroll_buffer_height

                        lda #007                        ; reset hardware scroll size
                        sta scroll_magnitude

                        ldx #000                        ; shift scroll text buffer 1 char left
shift_scroll_buffer     lda C_SCROLL_BUFFER_LOW + 1, x
                        sta C_SCROLL_BUFFER_LOW, x
                        lda C_SCROLL_BUFFER_HIGH + 1, x
                        sta C_SCROLL_BUFFER_HIGH, x
                        inx
                        cpx #039
                        bcc shift_scroll_buffer

                        ldx C_SCROLL_MESSAGE_INDEX      ; add next message character to buffer
load_next_scroll_char   lda C_SCROLL_MESSAGE, x
                        cmp #255                        ; detect end of message
                        bne advance_message_index

                        lda #>C_SCROLL_MESSAGE
                        sta load_next_scroll_char + 2
                        lda #032
                        ldx #000
                        jmp save_scrollmsg_index

advance_message_index   inx
                        bne save_scrollmsg_index
                        inc load_next_scroll_char + 2

save_scrollmsg_index    stx C_SCROLL_MESSAGE_INDEX      ; updated message character index

append_next_scroll_char ldy #$30                        ; default high source byte
                        cmp #031
                        bcc calc_character_data_pos
                        ldy #$31                        ; adjust high source byte
                        and #031                        
calc_character_data_pos asl                             ; x8 to get offset
                        asl
                        asl
                        sta C_SCROLL_BUFFER_LOW + 39    ; store high and low source bytes
                        sty C_SCROLL_BUFFER_HIGH + 39

                        jmp detect_logos_rendered

scroll_buffer_height    clc                             ; advance dycp scroller sine
                        lda C_SCROLL_SINE_INDEX
                        adc #001
                        and #031
                        sta C_SCROLL_SINE_INDEX

                        tay                             ; build height table for next dycp render
                        ldx #039
update_height_buffer    lda small_sine_table, y
                        sta C_SCROLL_BUFFER_HEIGHT, x
                        iny
                        tya
                        and #031
                        tay
                        dex
                        bpl update_height_buffer          


detect_logos_rendered   ldy logo_index                  ; are both logos rendered?
                        beq continue_to_next_split

                        ldy #254
                        sty REG_RASTERLINE
                        lda #<update_sprite_bounce
                        ldx #>update_sprite_bounce
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH
                        jmp logo_split_done

continue_to_next_split  lda logo_split_top_a, y         ; need to render bottom logo
                        sta REG_RASTERLINE
                        lda #<logo_split_resetbank
                        ldx #>logo_split_resetbank
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

logo_split_done         jmp $ea81



                        ; logo split - reset vic bank -------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

logo_split_resetbank    inc REG_INTFLAG                 ; acknowledge interrupt
                                                        ; TODO: Can merge this with another split between logo and text scroller..
                        lda $dd00                       ; reset VIC bank to 3
                        and #252
                        ora #003
                        sta $dd00

                        inc logo_index                  ; logo now rendered

                        ldy #094
                        sty REG_RASTERLINE
set_postbankreset_low   lda #<transition_scroller
set_postbankreset_high  ldx #>transition_scroller
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH
    
                        jmp $ea81


                        ; render animated raster bars -------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

render_animated_bars    clc

                        ldx #000                        ; render greets raster bars
next_animated_bar       lda C_ANIM_SCROLL_TABLE, x      ; apply scroll on every line
                        sta REG_SCREENCTL_2
                        lda C_ANIM_BAR_TABLE + 4, x
                        sta REG_BGCOLOUR

                        txa
                        and #007                        ; no waiting on bad scan lines
                        bne raster_wait
                        inx
                        jmp next_animated_bar

raster_wait             ldy #005                        ; delay until line complete
latch_raster            dey
                        bpl latch_raster
                        nop

no_wait                 inx
                        cpx #024                        ; render 24 bars
                        bne next_animated_bar

rasters_done            lda #000                        ; reset background colour
                        sta REG_BGCOLOUR

                        lda #$c8                        ; 40 column mode + no scroll
                        sta REG_SCREENCTL_2

                        inc REG_INTFLAG                 ; acknowledge interrupt

                        ldy #205
                        sty REG_RASTERLINE
set_postbars_low        lda #<logo_split_toprow
set_postbars_high       ldx #>logo_split_toprow
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH
    
                        jmp $ea81


                        ; transition raster bars into view --------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]
                        
transition_bars         inc REG_INTFLAG

                        dec bars_transition_smooth
                        bne skip_transition
                        lda #031
                        sta bars_transition_smooth

                        clc
                        ldx C_ANIM_BAR_TRAN_INDEX
                        lda #007
                        sbc C_ANIM_BAR_TRAN_INDEX
                        tay

                        lda animated_bar_table, x
                        sta C_ANIM_BAR_COLOURS, x
                        lda animated_bar_table, y
                        sta C_ANIM_BAR_COLOURS, y
                        lda animated_bar_table + 8, x
                        sta C_ANIM_BAR_COLOURS + 8, x
                        lda animated_bar_table + 8, y
                        sta C_ANIM_BAR_COLOURS + 8, y
                        lda animated_bar_table + 16, x
                        sta C_ANIM_BAR_COLOURS + 16, x
                        lda animated_bar_table + 16, y
                        sta C_ANIM_BAR_COLOURS + 16, y

                        inx
                        stx C_ANIM_BAR_TRAN_INDEX
                        cpx #004
                        bcc skip_transition

                        lda #<update_rasterbar_move
                        sta set_postbankreset_low + 1
                        lda #>update_rasterbar_move
                        sta set_postbankreset_high + 1

                        inc C_TEXT_BARS_ACTIVE

skip_transition         ldy #098
                        sty REG_RASTERLINE
                        lda #<update_rasterbar_move
                        ldx #>update_rasterbar_move
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        jmp $ea81


                        ; render scroller raster bars -------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

                        ; render top 8 raster bars on scroller

render_scroller_top     inc REG_INTFLAG               ; acknowledge interrupt

                        clc
                        lda REG_SCREENCTL_2           ; 38 column mode + scroll
                        and #240
                        adc scroll_magnitude
                        sta REG_SCREENCTL_2

scroll_top_first_colour lda C_SCROLLER_BAR_COLOURS    ; set first colour - bad line
                        sta REG_BORCOLOUR
                        sta REG_BGCOLOUR
                        nop
                        nop
                        nop
                        nop

                        ldy #001                      ; render remaining colours
next_top                lda C_SCROLLER_BAR_COLOURS, y
                        sta REG_BORCOLOUR
                        sta REG_BGCOLOUR

                        ldx #007                      ; delay until line complete
latch_scroll_raster_top dex
                        bpl latch_scroll_raster_top
                        eor REG_ZERO_02               ; stabalise raster (3 cycles)

                        iny
                        cpy #008
                        bne next_top

scroller_rasters_done   lda #000                      ; set scroller background
                        sta REG_BORCOLOUR
                        sta REG_BGCOLOUR

                        ldy #154
                        sty REG_RASTERLINE
                        lda #<render_scroller_bot
                        ldx #>render_scroller_bot
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH
    
                        jmp $ea81


                        ; render bottom 8 raster bars on scroller

render_scroller_bot     inc REG_INTFLAG               ; acknowledge interrupt

                        lda REG_SCREENCTL_2           ; 40 column mode + no scroll
                        ora #008
                        and #248
                        sta REG_SCREENCTL_2

scroll_bot_first_colour lda C_SCROLLER_BAR_COLOURS + $07  ; set first colour - bad line
                        sta REG_BORCOLOUR
                        sta REG_BGCOLOUR
                        nop
                        nop
                        nop
                        nop

                        ldy #006                      ; render remaining colours
next_bot                lda C_SCROLLER_BAR_COLOURS, y
                        sta REG_BORCOLOUR
                        sta REG_BGCOLOUR

                        ldx #007                      ; delay until line complete
latch_scroll_raster_bot dex
                        bpl latch_scroll_raster_bot
                        eor REG_ZERO_02               ; stabalise raster (3 cycles)

                        dey
                        cpy #255
                        bne next_bot

                        lda #000                      ; restore bg and border colours
                        sta REG_BORCOLOUR
                        sta REG_BGCOLOUR

set_postscroll_line     ldy #178
                        sty REG_RASTERLINE
set_postscroll_low      lda #<render_animated_bars
set_postscroll_high     ldx #>render_animated_bars
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH
    
                        jmp $ea81


                        ; transition scroller ---------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]
                        
transition_scroller     inc REG_INTFLAG

                        dec scroll_trans_smooth
                        bne skip_scroll_transition
                        lda #005
                        sta scroll_trans_smooth

                        clc

                        lda scroll_top_first_colour + 1
                        adc #008
                        sta scroll_top_first_colour + 1
                        sta next_top + 1
                        sta next_bot + 1

                        adc #007
                        sta scroll_bot_first_colour + 1

                        ldx C_SCROLL_TRANS_INDEX
                        lda C_SCROLLER_BAR_COLOURS + 28, x
                        sta scroller_rasters_done + 1

                        inx
                        stx C_SCROLL_TRANS_INDEX                ; 3 steps to full transition in
                        cpx #003 

                        bne skip_scroll_transition

                        lda #<transition_bars
                        sta set_postbankreset_low + 1
                        lda #>transition_bars
                        sta set_postbankreset_high + 1

                        inc C_SCROLLER_ACTIVE                   ; flag scroller as active

skip_scroll_transition  ldy #130
                        sty REG_RASTERLINE
                        lda #<render_scroller_top
                        ldx #>render_scroller_top
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        jmp $ea81


                        ; update raster bar movement --------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

update_rasterbar_move   inc REG_INTFLAG

                        dec animated_bar_smoothing      ; raster bar animation smoothing
                        bmi update_raster_bar_anim

                        clc
                        lda C_TEXT_WAVE_SINE_INDEX      ; advance greets text wave index
                        tay
                        adc #001
                        and #031
                        sta C_TEXT_WAVE_SINE_INDEX

                        sty REG_ZERO_03
                        lda #$c0                        ; 38 column mode
                        sta REG_ZERO_04

                        ldx #000                        ; precalc scroll offset for text wave
update_wave_text_table  lda REG_ZERO_03
                        and #031
                        tay
                        lda small_sine_table, y
                        adc REG_ZERO_04

                        sta C_ANIM_SCROLL_TABLE + 1, x  ; first and last scan line are blank

                        inc REG_ZERO_03

                        inx
                        cpx #023                        ; first and last scan lines can be skipped due to font
                        bcc update_wave_text_table
                        jmp cycle_scroller_colours


update_raster_bar_anim  lda #001                        ; reset smoothing
                        sta animated_bar_smoothing

                        ldx #007                        ; clear raster bar render table
                        lda #000
clear_raster_bar_table  sta C_ANIM_BAR_TABLE + 4, x
                        sta C_ANIM_BAR_TABLE + 12, x
                        sta C_ANIM_BAR_TABLE + 20, x
                        dex 
                        bpl clear_raster_bar_table
                        
                        clc
                        ldx #002                        ; 3 raster bars
                        stx REG_ZERO_03
                        ldx #000                        ; offset into raster bar source table
                        stx REG_ZERO_02

update_raster_bars      ldx REG_ZERO_03
                        lda animated_bar_indexs, x
                        adc #001
                        and #063
                        sta animated_bar_indexs, x
                        tax
                        lda bars_sine, x
                        tax

                        ldy #007                        ; 5 rows per bar
                        sty REG_ZERO_04

                        ldy REG_ZERO_02
copy_raster_bar         lda C_ANIM_BAR_COLOURS, y
                        sta C_ANIM_BAR_TABLE, x
                        iny
                        inx
                        dec REG_ZERO_04
                        bpl copy_raster_bar

                        sty REG_ZERO_02

                        dec REG_ZERO_03
                        bpl update_raster_bars


cycle_scroller_colours  lda C_TEXT_BARS_ACTIVE          ; cycle scroller colours when active
                        beq rasterbars_update_done

                        ldy #038                        ; cycle colour ram right
shift_scroller_colours  lda $d9b8, y
                        sta $d9b9, y
                        lda $d9e0, y
                        sta $d9e1, y
                        dey
                        bpl shift_scroller_colours

                        ldx scroll_colours_delay        ; get closer to special highlight colours
                        dex
                        bne load_special_scroll_col

                        ldx #241                        ; delay until next highlight
                        jmp user_default_scroll_col

load_special_scroll_col cpx #010                         ; grab next highlight colour
                        bcs user_default_scroll_col
                        lda scroller_colour_cycle, x
                        jmp user_default_scroll_col + 2

user_default_scroll_col lda #014                        ; default scroller colour                       
                        sta $d9b8                       ; insert next colour
                        sta $d9e0

                        stx scroll_colours_delay

rasterbars_update_done  ldy #130
                        sty REG_RASTERLINE
                        lda #<render_scroller_top
                        ldx #>render_scroller_top
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        jmp $ea81


                        ; update routine --------------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

update_sprite_bounce    inc REG_INTFLAG                         ; acknowledge interrupt

                        ldy #000                                ; reset logo render index
                        sty logo_index

                        ; logo transition update

                        ldx C_LOGO_TRANS_ACTIVE                 ; active logo transition?
                        beq no_logo_transition

                        dec logo_trans_smoothing                ; apply smoothing to logo transition
                        bpl logo_transition_done
                        lda #005
                        sta logo_trans_smoothing

logo_fade_in            inc C_LOGO_COL_INDEX_1                  ; update logo colour indexes
logo_fade_out           dec C_LOGO_COL_INDEX_2
                        dec C_LOGO_TRANS_STEP
                        bpl logo_transition_done

                        dec C_LOGO_TRANS_ACTIVE                 ; transition complete, deactivate

                        clc                                     ; swap inc/dec indexes
t1                      lda C_LOGO_COL_INDEX_2
                        adc #012
                        cmp #042
                        bcc t2
                        clc
                        sbc #041                                ; loop at end of colour table
t2                      sta C_LOGO_COL_INDEX_2

swap                    lda logo_fade_in + 1
                        sta REG_ZERO_02
                        lda logo_fade_out + 1
                        sta logo_fade_in + 1
                        lda REG_ZERO_02
                        sta logo_fade_out + 1
                        sta t1 + 1
                        sta t2 + 1

active_logo_trans_done  jmp logo_transition_done

no_logo_transition      dec C_LOGO_TRANS_DELAY                  ; apply delay between transitions
                        bne logo_transition_done
                        inc C_LOGO_TRANS_ACTIVE
                        ldx #002
                        stx C_LOGO_TRANS_STEP
                        lda C_LOGO_TRANS_DELAY
                        ldx #141
                        stx C_LOGO_TRANS_DELAY

logo_transition_done    clc

                        lda logo_sine_offset                    ; update logo swing position
                        adc #001
                        and #127
                        sta logo_sine_offset
                        clc
                        lda logo_sine_offset + 1
                        adc #001
                        and #127
                        sta logo_sine_offset + 1

                        lda #$34                                ; reset dycp render pointers
                        sta ss + 2
                        sta ss2 + 2
                        lda #$35
                        sta ss3 + 2
                        sta ss4 + 2
                        lda #$36
                        sta ss5 + 2
                        lda #$00
                        sta ss + 1
                        sta ss3 + 1
                        sta ss5 + 1
                        lda #$80
                        sta ss2 + 1
                        sta ss4 + 1
                        
                        clc 
                        ldx #007
                        stx REG_ZERO_03
                        ldx #000

render_dycp_message     lda C_SCROLL_BUFFER_LOW, x
                        sta render_dycp_char1 + 1
                        lda C_SCROLL_BUFFER_HIGH, x
                        sta render_dycp_char1 + 2
                        lda C_SCROLL_BUFFER_HEIGHT, x
                        adc ss + 1
                        sta ss + 1
                        lda C_SCROLL_BUFFER_LOW + 8, x
                        sta render_dycp_char2 + 1
                        lda C_SCROLL_BUFFER_HIGH + 8, x
                        sta render_dycp_char2 + 2
                        lda C_SCROLL_BUFFER_HEIGHT + 8, x
                        adc ss2 + 1
                        sta ss2 + 1
                        lda C_SCROLL_BUFFER_LOW + 16, x
                        sta render_dycp_char3 + 1
                        lda C_SCROLL_BUFFER_HIGH + 16, x
                        sta render_dycp_char3 + 2
                        lda C_SCROLL_BUFFER_HEIGHT + 16, x
                        adc ss3 + 1
                        sta ss3 + 1
                        lda C_SCROLL_BUFFER_LOW + 24, x
                        sta render_dycp_char4 + 1
                        lda C_SCROLL_BUFFER_HIGH + 24, x
                        sta render_dycp_char4 + 2
                        lda C_SCROLL_BUFFER_HEIGHT + 24, x
                        adc ss4 + 1
                        sta ss4 + 1
                        lda C_SCROLL_BUFFER_LOW + 32, x
                        sta render_dycp_char5 + 1
                        lda C_SCROLL_BUFFER_HIGH + 32, x
                        sta render_dycp_char5 + 2
                        lda C_SCROLL_BUFFER_HEIGHT + 32, x
                        adc ss5 + 1
                        sta ss5 + 1

                        ldy #000
render_dycp_char1       lda $3000, y
ss                      sta $3400, y
render_dycp_char2       lda $3000, y
ss2                     sta $3480, y
render_dycp_char3       lda $3000, y
ss3                     sta $3500, y
render_dycp_char4       lda $3000, y
ss4                     sta $3580, y
render_dycp_char5       lda $3000, y
ss5                     sta $3600, y
                        iny
                        cpy #008
                        bne render_dycp_char1

                        clc
                        lda #016
                        sbc C_SCROLL_BUFFER_HEIGHT, x
                        adc ss + 1
                        sta ss + 1
                        lda #016
                        sbc C_SCROLL_BUFFER_HEIGHT + 8, x
                        adc ss2 + 1
                        sta ss2 + 1
                        lda #016
                        sbc C_SCROLL_BUFFER_HEIGHT + 16, x
                        adc ss3 + 1
                        sta ss3 + 1
                        lda #016
                        sbc C_SCROLL_BUFFER_HEIGHT + 24, x
                        adc ss4 + 1
                        sta ss4 + 1
                        lda #016
                        sbc C_SCROLL_BUFFER_HEIGHT + 32, x
                        adc ss5 + 1
                        sta ss5 + 1

                        inx

                        dec REG_ZERO_03
                        bmi colour_update_complete
                        jmp render_dycp_message

colour_update_complete  ldy #029
                        sty REG_RASTERLINE
                        lda #<update_music
                        ldx #>update_music
                        sta REG_INTSERVICE_LOW
                        stx REG_INTSERVICE_HIGH

                        jmp $ea81


                        ; data tables -----------------------------------------------------------------------------------------------------]
                        ; -----------------------------------------------------------------------------------------------------------------]

                        ; intro smoothing variables

fade_smoothing          .byte 001
clear_smoothing         .byte 001

                        ; demo intro transition variables

clear_screen_sprite_x   .byte 024, 072, 120, 168, 216, 008, 056
split_raster_rows       .byte 000, 050, 090, 130, 170, 210, 250
fade_colour_sequence    .byte 014, 015, 007, 013, 003, 014, 004, 006, 000
intro_fade_delay_table  .byte 042, 051, 055, 062, 060, 054, 047

                        ; logo transition & colour variables

logo_colour_sequences   .byte 000, 000, 000, 011, 012, 015
                        .byte 000, 000, 000, 006, 014, 003
                        .byte 000, 000, 000, 002, 010, 007
                        .byte 000, 000, 000, 009, 005, 013
                        .byte 000, 000, 000, 002, 012, 015
                        .byte 000, 000, 000, 008, 005, 007
                        .byte 000, 000, 000, 006, 004, 010
                        .byte 000, 000, 000, 000, 000, 000
logo_trans_smoothing    .byte 001
logo_index              .byte 000
logo_sine_offset        .byte 000, 063
logo_y_pos              .byte 050, 208

logo_split_top_row      .byte 060, 218
logo_split_bot_row      .byte 070, 228
logo_split_top_a        .byte 093

                        ; glow text variables

colour_glow_sequence    .byte 011, 012, 015, 007, 007, 015, 010, 012, 008, 011, 002, 009
colour_glow_indexs      .byte 000, 000, 017
glow_smoothing          .byte 255
credits_code            .byte 003, 015, 004, 005, 058, 010, 005, 019, 004, 005, 018, 032
credits_logo            .byte 012, 015, 007, 015, 032, 001, 018, 020, 058, 010, 019, 012
credits_music           .byte 020, 021, 014, 005, 058, 020, 018, 009, 004, 005, 014, 020

                        ; greets messages
                        
display_text_a          .byte 096, 096, 071, 082, 069, 069, 084, 083, 096, 084, 079, 122, 096, 096, 079, 078
                        .byte 083, 076, 065, 085, 071, 072, 084, 108, 096, 068, 069, 070, 065, 077, 069, 108
                        .byte 096, 076, 073, 071, 072, 084, 096, 096                                                
display_text_b          .byte 096, 096, 096, 073, 075, 065, 082, 073, 108, 096, 083, 079, 083, 108, 096, 067
                        .byte 065, 077, 069, 076, 079, 084, 108, 096, 067, 082, 069, 083, 084, 108, 096, 079
                        .byte 088, 089, 082, 079, 078, 096, 096, 096
display_text_c          .byte 096, 096, 067, 069, 078, 083, 079, 082, 108, 096, 072, 079, 075, 065, 084, 085
                        .byte 096, 070, 079, 082, 067, 069, 108, 096, 077, 079, 078, 108, 096, 070, 065, 073
                        .byte 082, 076, 073, 071, 072, 084, 096, 096

                        ; animated raster bar variables

animated_bar_smoothing  .byte 001
animated_bar_scr_smooth .byte 002
bars_transition_smooth  .byte 255
animated_bar_table      .byte 006, 004, 014, 003, 003, 014, 004, 006
                        .byte 009, 008, 005, 013, 013, 005, 008, 009
                        .byte 002, 010, 007, 001, 001, 007, 010, 002
animated_bar_indexs     .byte 032, 016, 000

                        ; sine tables

logo_sine_table         .byte 000, 000, 000, 000, 001, 001, 001, 002, 002, 003, 004, 005, 006, 007, 008, 009
                        .byte 010, 011, 012, 013, 014, 015, 016, 017, 018, 019, 020, 021, 022, 023, 024, 025
                        .byte 026, 027, 028, 029, 030, 031, 032, 033, 034, 035, 036, 037, 038, 039, 040, 041
                        .byte 042, 043, 044, 045, 046, 047, 048, 049, 050, 051, 052, 052, 053, 053, 053, 054
                        .byte 054, 054, 054, 053, 053, 053, 052, 052, 051, 051, 050, 049, 048, 047, 046, 045
                        .byte 044, 043, 042, 041, 040, 039, 038, 037, 036, 035, 034, 033, 032, 031, 030, 029
                        .byte 028, 027, 026, 025, 024, 023, 022, 021, 020, 019, 018, 017, 016, 015, 014, 013
                        .byte 012, 011, 010, 009, 008, 007, 006, 005, 004, 003, 003, 002, 002, 001, 001, 001

small_sine_table        .byte 000, 000, 000, 001, 001, 001, 002, 002, 003, 004, 004, 005, 005, 006, 006, 006
                        .byte 007, 007, 007, 007, 006, 006, 006, 005, 005, 004, 004, 003, 002, 002, 001, 001

bars_sine               .byte 000, 000, 000, 000, 001, 001, 002, 002, 003, 003, 004, 005, 006, 007, 008, 009
                        .byte 010, 011, 012, 013, 014, 015, 016, 017, 018, 019, 020, 020, 021, 021, 022, 022
                        .byte 023, 023, 023, 023, 022, 022, 021, 021, 020, 020, 019, 018, 017, 016, 015, 014
                        .byte 013, 012, 011, 010, 009, 008, 007, 006, 005, 004, 003, 003, 002, 002, 001, 001

                        ; scroller variables

scroll_trans_smooth     .byte 150
scroll_magnitude        .byte 007
scroll_colours_delay    .byte 090
scroller_colour_cycle   .byte 012, 012, 015, 015, 001, 001, 015, 015, 012, 012
scroller_bar_colours    .byte 006, 000, 000, 000, 000, 006, 000, 006
                        .byte 014, 006, 006, 000, 006, 014, 006, 014
                        .byte 003, 014