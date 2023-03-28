Lc002 = * + 2
Lc000               jmp BEGIN

Lc003               jmp OFF

BEGIN               jsr INIT
READY               jmp RREADY

GETCH2              inc GETPTR
                    bne NOTO
                    inc GETPTR+1
NOTO                jsr CHRGOT
                    stx TEMPX
                    sty TEMPY
                    tsx
                    lda $0101,x
                    cmp #$8c
                    bne OLDGET
                    lda $0102,x
                    cmp #$a4
                    beq GOODCALL
OLDGET              ldx TEMPX
                    ldy TEMPY
                    jmp CHRGOT

CKAUTO              jsr AUTOLN
                    jmp CHRGOT

GOODCALL            jsr CHRGOT
                    bcc CKAUTO

                    cmp #$3e
                    bne OLDGET
                    jsr CHRGET
                    pla
                    pla

                    ; CHECK FOR VALID COMMANDS
                    ldx #$00
                    stx TOKNUM
USERTOK             ldy #$00
TOKLOOP             lda TOKTBLE,x
                    beq GOODTOK
                    cmp (GETPTR),y
                    bne NEXTTOK
                    inx
                    iny
                    bne TOKLOOP
NEXTTOK             inx
                    lda TOKTBLE,x
                    bne NEXTTOK
                    inx
                    inc TOKNUM
                    lda TOKTBLE,x
                    beq SERROR2
                    bne USERTOK
SERROR2             jmp OURERR

GOODTOK             jsr UPDATE
                    lda TOKNUM
                    asl a
                    tax
                    lda TOKADD,x
                    sta TOKVCTR
                    lda $c08a,x
                    sta $cfdb
                    jsr CHRGOT
                    jmp (TOKVCTR)

TOKADD                                         97 c8 35 c7 fc c4 0f
                    c7 76 c7 b7 c1 78 c2 57 c3 23 c6 16 c5 7f cb b3
                    c0 83 c4 f0 c1 d7 c8 48 c8 6a c2 0d c2 9a c3 9f
                    c1 b8 cd
MERGE               ldx #$11
                    stx FILELEN
                    jsr INPFILE
                    jsr STRTMSGE
                    lda #$02
                    ldx #$08
                    ldy #$00
                    jsr OPENFILE
CONT1               ldx #$02
                    jsr CHKIN
                    ldx #$00
                    jsr GETCHR
                    jsr GETCHR
LNLOOP              jsr GETCHR
                    jsr GETCHR
                    cmp #$00
                    bne CONT2
                    jmp PGMOVER

CONT2               jsr GETLN
                    ; PUT THE LINE IN
                    jsr PUTIN
                    jmp LNLOOP

PGMOVER             jsr CGRET
                    jmp DS

                    ; GET A BASIC LINE
GETLN               ldx #$ff
                    jsr GETCHR
                    sta INTVAL
                    jsr GETCHR
                    sta $15
                    stx TEMPX
                    lda $15
                    ldx INTVAL
                    jsr PRINTLN
                    jsr CGRET
                    lda #$91
                    jsr PRINT
                    lda #$cb
                    ldy #$ce
                    jsr STROUT
                    ldx TEMPX
LL5                 inx
                    cpx #$4e
                    bcs LL4
                    jsr GETCHR
                    sta BUFF,x
                    cmp #$00
                    bne LL5
LL4                 inx
                    inx
                    sta BUFF,x
                    inx
                    inx
                    inx
                    ; BUFF PTR
                    stx $0b
                    rts

SERROR              lda #$22
                    sta DELIM
                    jmp SYNERROR

INPFILE             ldx #$00
                    ldy #$00
                    cmp DELIM
                    bne SERROR
FILELOOP            cpx FILELEN
                    beq STRERR
                    jsr CHRGET2
                    beq NAMEDONE
                    cmp DELIM
                    beq NAMEDON
                    sta FILENAME,x
                    inx
                    bne FILELOOP
NAMEDON             iny
NAMEDONE            cpx #$00
                    beq SERROR
                    stx NUMCHAR
                    lda #$00
                    sta FILENAME,x
                    jsr UPDATE
                    ldx #$a0
                    ldy #$cf
                    lda NUMCHAR
                    jsr SETNAM
                    lda #$22
                    sta DELIM
                    jmp CHRGOT

                    ; STRING TOO LONG MESSAGE
STRERR              lda #$22
                    sta DELIM
                    ldx #$17
                    jmp ERROREX

                    ; ERROR ROUTINES
STERROR             cpy #$40
                    bne CONTT
                    jmp PGMOVER

CONTT               jmp DS

GETCHR              jsr SERIN
                    ldy ST
                    bne STERROR
                    rts

STRTMSGE            lda #$bb
                    ldy #$ce
                    jmp STROUT

CHRGET2             iny
                    lda (GETPTR),y
                    rts

LOAD                ldx #$11
                    stx FILELEN
                    jsr INPFILE
                    lda #$01
                    ldx #$08
                    ldy #$01
                    jsr SETLFS
                    lda #$00
                    sta $0a
                    jmp SYSLOAD

DS                  lda #$01
                    jsr CLOSE
                    lda #$02
                    jsr CLOSE
                    jsr CLALL
                    lda #$20
                    jsr PRINT
                    lda #$00
                    jsr SETNAM
                    jsr OPENCC
                    ldx #$01
                    jsr CHKIN
DSLOOP              jsr SERIN
                    jsr PRINT
                    cmp #$0d
                    bne DSLOOP
                    lda #$20
                    jsr PRINT2
                    lda #$01
                    jsr CLOSE
                    jsr CLALL
                    jmp READY

OFF                 lda #$8a
                    ldy #$cf
                    jsr STROUT
                    jsr RESGETT
                    jmp READY

RESGETT             ldx #$02
RESGET              lda SAVETBLE,x
                    sta CHRGET,x
                    lda #$00
                    sta SAVETBLE,x
                    dex
                    bpl RESGET
                    rts

START               ldx #$11
                    stx FILELEN
                    jsr INPFILE
                    lda #$02
                    ldx #$08
                    ldy #$00
                    jsr OPENFILE
                    ldx #$02
                    jsr CHKIN
                    jsr SERIN
                    jsr TIMER
                    tax
                    stx TEMPX
                    jsr SERIN
                    jsr TIMER
                    sta TEMPY
                    lda #$02
                    jsr CLOSE
                    jsr CLALL
                    lda #$24
                    jsr PRINT
                    lda TEMPY
                    ldx TEMPX
                    jsr PRINTADD
                    jsr SPACE
                    jsr PRINT
                    lda TEMPY
                    ldx TEMPX
                    jsr PRINTLN
                    jsr SPACE
                    jsr CGRET
                    jmp DS

TIMER               ldy #$64
TIMELOOP            dey
                    bne TIMELOOP
                    rts

SEND                ldx #$50
                    stx FILELEN
                    jsr INPFILE
                    jsr OPENCC
                    jmp DS

HELP                lda #$a0
                    ldy #$ce
                    jsr STROUT
                    ldy #$00
LABEL               lda TOKTBLE,y
                    cmp #$5e
                    beq END2
                    jsr SPACE
                    lda #$3e
                    jsr PRINT
HELPLOOP            lda TOKTBLE,y
                    beq END1
                    jsr PRINT
                    iny
                    bne HELPLOOP
END1                jsr CGRET
END3                iny
                    lda TOKTBLE,y
                    bne LABEL
                    jmp READY

END2                iny
                    lda TOKTBLE,y
                    bne END2
                    jmp END3

                    ; INITIALIZE
INIT                lda BLOCK
                    cmp #$a0
                    bcs OVERIT
                    cmp $38
                    bcs OVERIT
                    sta $38
                    lda #$ff
                    sta TOM
                    jsr NEW

OVERIT              lda #$00
                    sta INCR
                    lda #$22
                    sta DELIM
                    ldx #$02
                    lda #$02
                    sta d020_vBorderCol
                    lda #$0f
                    sta d021_vBackgCol0
                    lda #$00
                    sta $0286
                    lda SAVETBLE,x
                    bne HELLOO
SAVEGET             lda CHRGET,x
                    sta SAVETBLE,x
                    dex
                    bpl SAVEGET
                    ldx #$02
INITGET             lda GETTBLE,x
                    sta CHRGET,x
                    dex
                    bpl INITGET
HELLOO              lda #$1e
                    ldy #$cf
                    jmp STROUT

SAVETBLE            e6 00 00 00
GETTBLE             4c 0c c0
OURERR              lda #$05
                    ldy #$cf
                    jsr STROUT
                    jmp READY

OPENCC              lda #$01
                    ldx #$08
                    ldy #$0f
OPENFILE            jsr SETLFS
                    jsr OPEN
                    ldy ST
                    beq OPENED
                    cmp #$80
                    bne JUMPDS
                    ldx #$05
                    jmp ERROREX

JUMPDS              jmp DS

OPENED              rts

PRINTNIB            clc
                    adc #$f6
                    bcc ADD2
                    adc #$06
ADD2                adc #$3a
                    jmp PRINT

PRINTBYT            pha
                    lsr a
                    lsr a
                    lsr a
                    lsr a
                    jsr PRINTNIB
                    pla
                    and #$0f
                    jmp PRINTNIB

PRINTADD            jsr PRINTBYT
                    txa
                    jmp PRINTBYT

OUROPEN             jsr OPEN
                    ldy ST
                    beq OKST
                    jmp DS

OKST                rts

HEX                 jsr CRUNCH
                    jsr CHRGET
                    cmp #$24
                    beq HEX2
                    jsr EVALEXP
                    jsr FLFXD
                    jsr SPACE
                    lda #$24
                    jsr PRINT
                    ldx INTVAL
                    lda $15
                    jsr PRINTADD
HEXEND              jsr SPACE
                    jsr CGRET
                    jmp READY

ABCDEF              jmp SYNERROR

HEX2                jsr INPADD
                    sta TEMPX
                    jsr SPACE
                    jsr CHRGET2
                    bne ABCDEF
                    txa
                    ldx TEMPX
                    jsr PRINTLN
                    jmp HEXEND

DISK                sta $cfa1
                    ldy #$ff
                    lda #$24
                    sta FILENAME
CATLOOP2            jsr CHRGET2
                    sta $cfa1,y
                    beq CNAMEOK
                    cpy #$31
                    bcc CATLOOP2
                    jmp STRERR

CNAMEOK             iny
                    sty NUMCHAR
                    iny
                    lda #$00
                    sta $cfa2,y
                    lda #$01
                    ldx #$08
                    ldy #$60
                    jsr SETLFS
                    jsr CGRET
                    jsr UNLSN
                    jsr UNTALK
                    lda NUMCHAR
                    ldx #$a0
                    ldy #$cf
                    jsr SETNAM
                    jsr OPEN
                    ldx #$01
                    jsr CHKIN
                    jsr SERIN
                    ; IGNORE LOAD ADDRESS
                    jsr SERIN
                    jsr SERIN
                    jsr SERIN
                    ldx ST
                    ; IGNORE LINK
                    bne CATDONE
                    lda #$20
                    jsr PRINT2
                    jsr SERIN
                    tax
                    jsr SERIN
                    ; PRINT PGM  # BLOCKS
                    jsr PRINTLN
                    lda #$20
                    jsr PRINT2
                    jsr PRINT2
                    jsr PRINT2
                    jsr PRINT2
DIRLOOP2            jsr SERIN
                    jsr PRINT2
                    bne DIRLOOP2
                    lda #$0d
                    jsr PRINT2
                    jmp GETLINK3

CATDONE             jsr UNTALK
                    jsr CGRET
                    jsr PRINT
                    jmp DS

GETLINK3            jsr SERIN
                    jsr SERIN
                    ldx ST
                    ; IGNORE LINK
                    bne CATDONE
                    lda #$20
                    jsr PRINT2
                    jsr SERIN
                    tax
                    jsr SERIN
                    ; PRINT PGM  # BLOCKS
                    jsr PRINTLN
                    lda #$20
                    jsr PRINT2
DIRLOOP3            jsr SERIN
                    jsr PRINT2
                    beq CATDONE
                    cmp #$22
                    bne DIRLOOP3
                    ldy #$12
CALNLOOP            jsr SERIN
                    cmp #$00
                    beq CATDONE
                    jsr PRINT2
                    dey
                    bne CALNLOOP
                    lda #$20
                    jsr PRINT2
                    jsr PRINT2
                    lda #$3a
                    jsr PRINT
CALNLP2             jsr SERIN
                    jsr PRINT2
                    bne CALNLP2
                    jsr STOPSHFT
                    beq CATDONE
                    lda #$0d
                    jsr PRINT2
                    jmp GETLINK3

NAME                cmp #$22
                    beq USERNAME
                    lda #$38
                    ldy #$ce
                    jsr STROUT
                    lda #$22
                    jsr PRINT
                    lda #$a0
                    ldy #$cf
                    jsr STROUT
                    lda #$22
                    jsr PRINT
                    lda #$da
                    ldy #$ce
                    jsr STROUT
                    jsr CGRET
                    lda #$91
                    jsr PRINT
                    ldx #$ff
                    txs
                    jmp bMAIN

USERNAME            ldx #$46
                    stx FILELEN
                    jsr INPFILE
                    jmp READY

INPADD              lda #$00
                    sta TEMPY
                    tay
                    jsr INPBYTE
                    tax
                    stx TEMP8
                    lda #$00
                    sta TEMPY
INPBYTE             jsr INPNIB
                    asl a
                    asl a
                    asl a
                    asl a
                    sta TEMPY
INPNIB              jsr CHRGET2
                    cmp #$30
                    bcc SERROR3
                    cmp #$3a
                    bcc O9
                    cmp #$41
                    bcc SERROR3
                    cmp #$47
                    bcs SERROR3
                    sbc #$06
O9                  and #$0f
                    ora TEMPY
                    ldx TEMP8
                    rts

SERROR3             jmp SYNERROR

COLD                lda #$00
                    ldx #$02
COLDLOOP            sta SAVETBLE,x
                    dex
                    bpl COLDLOOP
                    jmp $fce2

SPACE               lda #$20
                    jmp PRINT

CGRET               lda #$0d
                    jmp PRINT

                    ; W-64+ - FILE#2
FINI                jmp READY

DUMP                lda VARSTART
                    ldx $2e
                    sta VARPTR
                    stx VARPTR+1
                    jmp GETVAR

NEXTVAR             jsr STOPSHFT
                    beq FINI
                    jsr CGRET
                    lda #$07
                    clc
                    adc VARPTR
                    sta VARPTR
                    lda VARPTR+1
                    adc #$00
                    sta VARPTR+1
GETVAR              jsr SPACE
                    lda VARPTR+1
                    cmp $30
                    bcc DUMPOK
                    bne FINI
                    lda VARPTR
                    cmp STARRAY
                    bcs FINI
DUMPOK              ldy #$00
                    lda (VARPTR),y
                    bpl NOTINT
                    jmp INTEGER

NOTINT              jsr PRINT
                    jsr INCPTR
                    cmp #$80
                    bcs STRING
                    jsr PRINT
                    jsr EQUALS
                    lda #$9d
                    jsr PRINT
                    jsr INCPTR
                    tya
                    clc
                    adc VARPTR
                    sta TEMPX
                    lda VARPTR+1
                    adc #$00
                    sta TEMPY
                    lda TEMPX
                    ldy TEMPY
                    jsr LOADFAC1
                    jsr CONVFAC1
                    jsr STROUT
                    jmp NEXTVAR

STRING              and #$7f
                    jsr PRINT
                    lda #$24
                    jsr PRINT
                    jsr EQUALS
                    lda #$22
                    jsr PRINT
                    jsr INCPTR
                    sta STRLEN
                    jsr INCPTR
                    sta MOVETO
                    jsr INCPTR
                    sta STRPTR+1
                    ldy STRLEN
                    beq QUOTE
                    ldy #$00
PRLOOP              lda (MOVETO),y
                    jsr PRINT
                    iny
                    cpy STRLEN
                    bne PRLOOP
QUOTE               lda #$22
                    jsr PRINT
                    jmp NEXTVAR

INTEGER             and #$7f
                    jsr PRINT
                    jsr INCPTR
                    and #$7f
                    jsr PRINT
                    lda #$25
                    jsr PRINT
                    jsr EQUALS
                    jsr INCPTR
                    ; GET HI BYTE
                    sta TEMPA

                    ; HAS HIGH BIT SET IF NEG'VE
                    bpl PLUS
                    lda #$2d
                    jsr PRINT
                    lda TEMPA
                    eor #$ff
                    clc
                    adc #$00
                    pha
                    jsr INCPTR
                    eor #$ff
                    tax
                    inx
                    bne PULL
                    pla
                    clc
                    adc #$01
                    jmp PRINTIT

PULL                pla
                    jmp PRINTIT

PLUS                lda TEMPA
                    and #$7f
                    pha
                    jsr INCPTR
                    tax
                    pla
PRINTIT             jsr PRINTLN
                    jmp NEXTVAR

INCPTR              iny
                    lda (VARPTR),y
                    rts

EQUALS              jsr SPACE
                    lda #$3d
                    jsr PRINT
                    jmp SPACE

                    ; H U N T
HUNT                jsr CRUNCH
                    jsr CHRGET
                    ldx #$50
                    stx FILELEN
                    sta DELIM
                    jsr INPFILE

                    beq ONLYDL
                    jsr COMMA
ONLYDL              jsr LNRANGE

                    ldy MOVETO
                    ldx STRPTR+1
                    sty INTVAL
                    stx $15
                    lda #$04
                    clc
                    adc NUMCHAR
                    sta NUMCHAR
                    jsr FINDLN

NEWLINE             jsr STOPSHFT
                    beq ALLGONE
                    ldy #$01
                    ; HB LINK
                    lda (VARPTR),y
                    beq ALLGONE

                    iny
                    lda (VARPTR),y
                    ; GET LN#
                    sta INTVAL
                    iny
                    lda (VARPTR),y
                    sta $15
                    lda $15
                    cmp $27
                    ; CHECK HB
                    bcc HUNTLOOP
                    bne ALLGONE
                    lda INTVAL
                    cmp MOVEFROM
                    ; CHECK LB
                    beq HUNTLOOP
                    bcs ALLGONE
HUNTLOOP            ldy #$04
KEEPTRY             lda (VARPTR),y
                    beq NEXTLINE
                    cmp $cf9c,y
                    beq OKSOFAR
                    inc VARPTR
                    bne OKKKK
                    inc VARPTR+1
OKKKK               jmp HUNTLOOP

                    ; GOOD CHR->GET NEXT
OKSOFAR             iny
                    cpy NUMCHAR
                    bne KEEPTRY
                    jsr FINDLN
                    ; BINGO!
                    jsr PRLINE

NEXTLINE            tya
                    sec
                    ; UPDATE PTR TO
                    adc VARPTR
                    sta VARPTR
                    ; NEXT LINE
                    bcc NEWLINE
                    inc VARPTR+1
                    jmp NEWLINE

ALLGONE             jmp READY

PRLINE              ldy #$01
                    jsr SPACE
                    sty $0f
                    lda (VARPTR),y
                    beq LAB1
                    jsr bCRDO
                    iny
                    lda (VARPTR),y
                    tax
                    iny
                    lda (VARPTR),y
                    sty $49
                    jsr PRINTLN
                    lda #$20
LAB8                ldy $49
                    and #$7f
LAB4                jsr $ab47
                    cmp #$22
                    bne LAB2
                    lda $0f
                    eor #$ff
                    sta $0f
LAB2                iny
                    beq LAB1
                    lda (VARPTR),y
                    bne LAB3

                    ; ALL DONE
LAB1                rts

LAB3                bpl LAB4
                    cmp #$ff
                    beq LAB4
                    bit $0f
                    bmi LAB4
                    sec
                    sbc #$7f
                    tax
                    sty $49
                    ldy #$ff
LAB7                dex
                    beq LAB5

LAB6                iny
                    lda bRESLST,y
                    bpl LAB6
                    bmi LAB7

LAB5                iny
                    lda bRESLST,y
                    bmi LAB8
                    jsr $ab47
                    bne LAB5
STOPSHFT            jsr STOPKEY
                    beq GOBACK
SHIFTON             lda SHIFTKEY
                    cmp #$01
                    beq SHIFTON
GOBACK              rts

ILLEGAL             jmp ILLQTY

COL                 beq READYYYY
                    jsr GETFXD
                    bne ILLEGAL
                    sta d020_vBorderCol
                    jsr COMMA
                    jsr GETFXD
                    bne ILLEGAL
                    sta d021_vBackgCol0
                    jsr COMMA
                    jsr GETFXD
                    bne ILLEGAL
                    sta $0286
READYYYY            jmp READY

TOOBIG              jmp ILLQTY

AUTO                jsr GETFXD
                    bne TOOBIG
                    sta INCR
                    jmp READY

AUTOLN              jsr INPFXD
                    ldy INCR
                    beq GOBACK4
                    jsr CHRGOT
                    cmp #$00
                    beq GOBACK4
                    lda INCR
                    clc
                    adc INTVAL
                    tay
                    lda $15
                    adc #$00
                    jsr FXDFL
                    ldx #$00
KEYBLOOP            lda $0101,x
                    beq KEYBDONE
                    sta KEYB,x
                    inx
                    bne KEYBLOOP
KEYBDONE            inx
                    lda #$20
                    sta KEYB,x
                    inx
                    stx KEYBLEN
GOBACK4             jmp FOUNDNUM

DEL                 beq READYY
                    jsr CRUNCH
                    jsr CHRGET
                    jsr LNRANGE
                    lda MOVETO
                    ldx STRPTR+1
                    sta INTVAL
                    stx $15
                    jsr FINDLN
                    lda VARPTR
                    ldx VARPTR+1
                    sta MOVETO
                    stx STRPTR+1
                    ldx MOVEFROM
                    ldy $27
                    inx
                    bne STORE
                    iny
STORE               stx INTVAL
                    sty $15
                    jsr FINDLN
                    lda VARPTR
                    ldx VARPTR+1
                    sta MOVEFROM
                    stx $27

                    jsr DELMEM
                    jsr RECHAIN
                    lda RECHNPTR
                    clc
                    adc #$02
                    sta VARSTART
                    lda $23
                    adc #$00
                    sta $2e
                    jsr NEW
                    jmp READY

READYY              jmp SYNERROR

LNRANGE             ldy #$ff
                    sty $27
                    iny
                    sty MOVEFROM
                    sty MOVETO
                    sty STRPTR+1
                    jsr CHRGOT
                    beq GOBACK2
                    bcc PAR1
                    cmp #$ab
                    bne LASTLBL
                    jsr CHRGET
                    bcs BADPAR
                    jmp PAR2

BADPAR              jmp SYNERROR

PAR1                jsr INPFXD
                    lda INTVAL
                    ldx $15
                    sta MOVETO
                    stx STRPTR+1
                    jsr CHRGOT
                    cmp #$ab
                    bne BADPAR
                    jsr CHRGET
                    beq GOBACK2
                    bcc PAR2
GOBACK2             rts
LASTLBL             jmp SYNERROR

PAR2                jsr INPFXD
                    lda INTVAL
                    ldx $15
                    sta MOVEFROM
                    stx $27
                    jmp CHRGOT
DELMEM              ldy #$00
DELLOOP             lda $27
                    cmp $2e
                    bcc STARTDEL
                    bne DELDONE
                    lda MOVEFROM
                    cmp VARSTART
                    bcs DELDONE

STARTDEL            lda (MOVEFROM),y
                    sta (MOVETO),y
                    inc MOVEFROM
                    bne XXX
                    inc $27
XXX                 inc MOVETO
                    bne YYY
                    inc STRPTR+1
YYY                 bne DELLOOP
DELDONE             rts

SGETPTR             lda GETPTR
                    ldx GETPTR+1
                    sta VARPTR
                    stx VARPTR+1
                    rts

RGETPTR             lda VARPTR
                    ldx VARPTR+1
                    sta GETPTR
                    stx GETPTR+1
                    rts

SAVEM               jsr SAVEEE
                    jmp DS

SAVEEE              ldx #$11
                    stx FILELEN
                    jsr INPFILE
SAVEEEE2            lda #$01
                    ldx #$08
                    tay
                    jsr SETLFS

                    jsr CHRGOT
                    cmp #$2c
                    beq MLSAVE
                    lda #$2b
                    ldx VARSTART
                    ldy $2e
SAVEIT              jsr SAVEPROG
                    jmp CGRET

MLSAVE              jsr INPADD
                    sta MOVETO
                    stx STRPTR+1
                    jsr UPDATE
                    jsr CHRGET
                    cmp #$2c
                    bne MLSERR
                    jsr INPADD
                    stx TEMPX
                    tax
                    jsr UPDATE
                    ldy TEMPX
                    lda #$fd
                    jmp SAVEIT

MLSERR              jmp SYNERROR

ADJUST              ldx #$00
                    lda $0286
                    sta TEMPA
COLLOOP             stx TEMPB
                    lda COLTBLE,x
                    jsr PRINT
                    lda #$de
                    ldy #$ce
                    jsr STROUT
                    ldx TEMPB
                    inx
                    cpx #$10
                    bne COLLOOP
                    lda TEMPA
                    sta $0286
                    lda #$0d
                    ldx #$05
RETLOOP             jsr PRINT
                    dex
                    bne RETLOOP
                    jmp READY

UPDATE              tya
                    clc
                    adc GETPTR
                    sta GETPTR
                    lda GETPTR+1
                    adc #$00
                    sta GETPTR+1
                    rts

                    ; W-64.\ FILE#3
RENUM               jsr CRUNCH
                    jsr CHRGET
                    lda #$0a
                    sta RENINC
                    lda #$64
                    sta RENSTART
                    lda #$00
                    sta $cfe4
                    jsr CHRGOT
                    beq RENDEF
                    jsr GETFXD
                    sta RENSTART
                    stx $cfe4

                    jsr COMMA
                    jsr GETFXD
                    beq OKINC
                    jmp ILLQTY

OKINC               sta RENINC
                    jsr CHRGOT
                    beq RENDEF
                    jsr COMMA

RENDEF              jsr LNRANGE

                    lda RENSTART
                    ldx $cfe4
                    sta INTVAL
                    stx $15
                    jsr FINDLN
                    ldy #$03
                    lda (VARPTR),y
                    cmp STRPTR+1
                    bcc RANGEBAD
                    bne YOUBET
                    dey
                    lda (VARPTR),y
                    cmp MOVETO
                    bcc RANGEBAD
YOUBET              lda MOVETO
                    ldx STRPTR+1
                    sta INTVAL
                    stx $15
                    jsr FINDLN
                    lda VARPTR
                    ldx VARPTR+1
                    sta RENGET
                    stx $cfe6

                    lda MOVEFROM
                    ldx $27
                    sta RENENDLN
                    stx $cfea
                    sta INTVAL
                    stx $15
                    inc INTVAL
                    bne STCOUNT
                    inc $15
STCOUNT             jsr COUNTEM
                    jsr MULT
                    lda $8e
                    cmp #$fa
                    bcc RANGEOK
RANGEBAD            lda #$1b
                    ldy #$ce
                    jsr STROUT
                    jmp READY

RANGEOK             jsr FINDLN
                    jsr RGETPTR
                    ldy #$01
                    lda (GETPTR),y
                    beq THEMEAT
                    ldy #$03
                    lda $8e
                    cmp (GETPTR),y
                    bcc THEMEAT
                    bne RANGEBAD
                    lda RENTEMP
                    dey
                    cmp (GETPTR),y
                    bcs RANGEBAD
THEMEAT             lda STARTB
                    ldx $2c
                    sta GETPTR
                    stx GETPTR+1

                    ; PASS1
RESETQU             ldy #$00
                    sty QUMODE
LINKLOPP            ldy #$01
                    lda (GETPTR),y
                    bne LINKOK
RENDONE             jmp PASS2

LINKOK              iny
                    lda (GETPTR),y
                    sta INTVAL
                    iny
                    lda (GETPTR),y
                    sta $15
                    ldy #$04
                    jsr UPDATE
                    jsr SGETPTR3
                    ldy #$ff
ALOOP               iny
ALOOP2              lda (GETPTR),y
                    beq RLNDONE
                    cmp #$22
                    beq QUFOUND
                    ldx QUMODE
                    bne ALOOP
                    ldx #$06
TABLELOP            cmp BLOCK,x
                    beq RENBINGO
                    dex
                    bne TABLELOP
                    beq ALOOP
QUFOUND             lda QUMODE
                    eor #$ff
                    sta QUMODE
                    jmp ALOOP

RLNDONE             iny
                    jsr UPDATE
                    jmp RESETQU

RENBINGO            pha
                    jsr UPDATE
                    ldy #$00
                    pla
                    cmp #$cb
                    bne RENBING2
                    jsr CHRGET
                    cmp #$a4
                    bne ALOOP2
RENBING2            jsr CHRGET
                    bcs ALOOP2

                    jsr SINTVAL
                    jsr SGETPTR2
                    jsr CHRGOT
                    jsr STRFAC
                    jsr FLFXD

                    jsr CKRANGE
                    beq NEEDCHNG
                    jmp AFTERNUM

NEEDCHNG            lda INTVAL
                    ldx $15
                    sta RENENDLN
                    stx $cfea
                    jsr COUNTEM
                    beq SOMELAB
                    lda #$ff
                    sta RENCOUNT
                    sta $8c
SOMELAB             jsr SPACE

                    jsr MULT
                    ldx RENTEMP
                    lda $8e
                    stx INTVAL
                    sta $15
                    jsr PRINTLN
                    ldy RENTEMP
                    lda $8e
                    jsr FXDFL

                    jsr RGETPTR3
                    ldx #$ff

DOITLOOP            ldy #$00
                    inx
                    lda GETPTR+1
                    cmp $cfe8
                    bcc NOPROB2
                    bne DONETHIS
                    lda GETPTR
                    cmp TEMPC
                    bcs DONETHIS
NOPROB2             lda (GETPTR),y
                    sta BUFF,x
                    iny
                    jsr UPDATE
                    jmp DOITLOOP
DONETHIS            ldy #$00
                    lda $0100
                    cmp #$2d
                    bne BIGLOOP
                    sta BUFF,x
                    inx
BIGLOOP             lda $0101,y
                    beq DONEPT2
                    sta BUFF,x
                    iny
                    inx
                    bne BIGLOOP
DONEPT2             stx TEMPH
                    jsr RGETPTR2
                    jsr CHRGOT
                    jsr STRFAC
                    jsr CHRGOT
                    ldx TEMPH
                    ldy #$00
BIG2LOOP            cmp #$00
                    sta BUFF,x
                    beq DONEPT3
                    inx
                    iny
                    lda (GETPTR),y
                    jmp BIG2LOOP

DONEPT3             inx
                    inx
                    sta BUFF,x
                    inx
                    inx
                    inx
                    stx $0b
                    jsr RINTVAL
                    jsr PUTIN
                    jsr RGETPTR2
                    jsr STRFAC
                    lda MOVETO
                    ldx STRPTR+1
                    sta INTVAL
                    stx $15
                    jsr FINDLN
                    lda VARPTR
                    ldx VARPTR+1
                    sta RENGET
                    stx $cfe6

AFTERNUM            jsr RINTVAL

                    jsr CHRGOT
                    cmp #$2c
                    beq GETNEXT1
                    cmp #$ab
                    beq GETNEXT1
                    ldy #$00
                    sty QUMODE
                    jmp ALOOP2

GETNEXT1            jmp RENBING2

GETFXD              jsr INPFXD
GETINT              lda INTVAL
                    ldx $15
                    rts

MULT                lda RENINC
                    sta TEMPG
                    lda RENSTART
                    ldx $cfe4
                    sta RENTEMP
                    stx $8e
                    lda #$00
                    sta MULTFLAG

                    ldx #$08
MULTLOOP            lsr RENINC
                    bcc DONTADD
                    lda MULTFLAG
                    bne MULTERR
                    lda RENCOUNT
                    clc
                    adc RENTEMP
                    sta RENTEMP
                    lda $8c
                    adc $8e
                    sta $8e

DONTADD             asl RENCOUNT
                    rol $8c
                    rol MULTFLAG
                    dex
                    bne MULTLOOP

                    lda TEMPG
                    sta RENINC
                    rts

MULTERR             lda #$ff
                    sta RENTEMP
                    sta $8e
                    lda TEMPG
                    sta RENINC
                    rts

PASS2               lda RENGET
                    ldx $cfe6

                    sta GETPTR
                    stx GETPTR+1
PASS2LP             ldy #$01
                    lda (GETPTR),y
                    beq PASS2DN
                    ldy #$03
                    lda (GETPTR),y
                    cmp $27
                    bcc NOPROB
                    bne PASS2DN
                    dey
                    lda (GETPTR),y
                    cmp MOVEFROM
                    bcc NOPROB
                    bne PASS2DN
NOPROB              ldy #$02
                    lda RENSTART
                    sta (GETPTR),y
                    iny
                    lda $cfe4
                    sta (GETPTR),y

                    ldy #$00
                    lda (GETPTR),y
                    tax
                    iny
                    lda (GETPTR),y
                    sta GETPTR+1
                    stx GETPTR
                    lda RENINC
                    clc
                    adc RENSTART
                    sta RENSTART
                    bcc PASS2LP
                    lda $cfe4
                    adc #$00
                    sta $cfe4
                    jmp PASS2LP

PASS2DN             jmp READY

SERROR9             jmp SERROR

MEMORY              lda #$ff
                    sta MOVEFROM
                    sta $27
                    dec GETPTR
                    lda GETPTR
                    cmp #$ff
                    bne NOSUBT
                    dec GETPTR+1
NOSUBT              jsr INPADD
                    sta MOVETO
                    stx STRPTR+1
                    jsr UPDATE
                    jsr CHRGET
                    beq GETGOING
                    cmp #$2c
                    bne SERROR9
                    jsr INPADD
                    sta MOVEFROM
                    stx $27

GETGOING            jsr CGRET
LLOOPP              jsr STOPSHFT
                    beq PASS2DN
                    inc BLOCK
                    lda STRPTR+1
                    cmp BLOCK
                    bcc LETEM1
                    lda BLOCK
                    clc
                    adc #$10
                    sta TEMPH
                    ldy STRPTR+1
                    cpy TEMPH
                    bcs LETEM1

                    dec BLOCK
                    jmp READY

LETEM1              dec BLOCK
                    lda #$2e
                    jsr PRINT
                    lda STRPTR+1
                    ldx MOVETO
                    jsr PRINTADD
                    ldy #$00
PRINTMOR            jsr SPACE
                    lda (MOVETO),y
                    sty TEMPH
                    jsr PRINTBYT
                    ldy TEMPH
                    iny
                    cpy #$08
                    bne PRINTMOR
                    jsr SPACE
                    lda #$12
                    jsr PRINT
                    ldy #$00
BYTLOOP             lda (MOVETO),y
                    ldx #$00
                    stx QUMODE
                    cmp #$a1
                    bcs OOKK
                    cmp #$20
                    bcc NOTOOKK
                    cmp #$80
                    bcc OOKK
NOTOOKK             lda #$2e
OOKK                jsr PRINT
                    iny
                    cpy #$08
                    bne BYTLOOP

                    tya
                    clc
                    adc MOVETO
                    sta MOVETO
                    lda STRPTR+1
                    adc #$00
                    sta STRPTR+1
                    jsr CGRET

                    lda STRPTR+1
                    cmp $27
                    bcc GOLLOOPP
                    bne NOLLOOPP

                    lda MOVETO
                    cmp MOVEFROM
                    bcc GOLLOOPP
                    bne NOLLOOPP
GOLLOOPP            jmp LLOOPP

NOLLOOPP            jmp READY

                    ; PUT THE LINE IN   FIND BASIC LINE
PUTIN               jsr FINDLN
                    bcc L1
                    ldy #$01
                    lda (VARPTR),y
                    sta $23
                    lda VARSTART
                    sta RECHNPTR
                    lda VARPTR+1
                    sta $25
                    lda VARPTR
                    dey
                    sbc (VARPTR),y
                    clc
                    adc VARSTART
                    sta VARSTART
                    sta $24
                    lda $2e
                    adc #$ff
                    sta $2e
                    sbc VARPTR+1
                    tax
                    sec
                    lda VARPTR
                    sbc VARSTART
                    tay
                    bcs L2
                    inx
                    dec $25
L2                  clc
                    adc RECHNPTR
                    bcc L3
                    dec $23
                    clc
L3                  lda (RECHNPTR),y
                    sta ($24),y
                    iny
                    bne L3
                    inc $23
                    inc $25
                    dex
                    bne L3
L1                  jsr BACKTEXT
                    ; UNDER [NEW]
                    jsr NEW
                    jsr RECHAIN
                    lda BUFF
                    beq RETRN
                    clc
                    lda VARSTART
                    sta $5a
                    adc $0b
                    sta $58
                    ldy $2e
                    sty $5b
                    bcc L4
                    iny
L4                  sty $59
                    ; MOVE MEMORY
                    jsr MOVEMEM
                    lda INTVAL
                    ldy $15
                    sta $01fe
                    sty $01ff
                    lda $31
                    ; END BASIC
                    ldy $32
                    sta VARSTART
                    ; START BASIC VARS
                    sty $2e
                    ldy $0b
                    dey
L5                  lda $01fc,y
                    sta (VARPTR),y
                    dey
                    bpl L5
                    jsr BACKTEXT
                    ; UNDER [NEW]
                    jsr NEW
                    jsr RECHAIN
RETRN               rts

NEW                 lda TOM
                    ldy $38
                    sta $33
                    sty $34
                    lda VARSTART
                    ldy $2e
                    sta STARRAY
                    sty $30
                    sta $31
                    sty $32
                    jsr bRESTOR
                    ldx #$19
                    stx $16
                    lda #$00
                    sta $3e
                    sta $10
                    rts

COUNTEM             lda RENGET
                    ldx $cfe6
                    sta CNTPTR
                    stx $1a
                    ldy #$00
                    sty RENCOUNT
                    sty $8c

COUNTLP             ldy #$01
                    lda (CNTPTR),y
                    bne CNTNOVER
                    lda #$01
                    rts

CNTNOVER            ldy #$03
                    lda (CNTPTR),y
                    cmp $cfea
                    bcc CNTON
                    bne CNTDONE
                    dey
                    lda (CNTPTR),y
                    cmp RENENDLN
                    bcc CNTON

CNTDONE             rts

CNTON               ldy #$00
                    lda (CNTPTR),y
                    tax
                    iny
                    lda (CNTPTR),y
                    sta $1a
                    stx CNTPTR
                    inc RENCOUNT
                    bne COUNTLP
                    inc $8c
                    bne COUNTLP

SINTVAL             lda INTVAL
                    ldx $15
                    sta TEMPA
                    stx TEMPB
                    rts

RINTVAL             lda TEMPA
                    ldx TEMPB
                    sta INTVAL
                    stx $15
                    rts

SGETPTR2            lda GETPTR
                    ldx GETPTR+1
                    sta TEMPC
                    stx $cfe8
                    rts

RGETPTR2            lda TEMPC
                    ldx $cfe8
                    sta GETPTR
                    stx GETPTR+1
                    rts

CKRANGE             lda $15
                    cmp STRPTR+1
                    beq ISEQU
                    bcs CKENDPTR
NOTRNGE             lda #$01
                    rts
INRANGE             lda #$00
                    rts

ISEQU               lda INTVAL
                    cmp MOVETO
                    bcc NOTRNGE

CKENDPTR            lda $15
                    cmp $27
                    bcc INRANGE
                    bne NOTRNGE
                    lda INTVAL
                    cmp MOVEFROM
                    bcc INRANGE
                    beq INRANGE
                    bcs NOTRNGE

FXDFL               cmp #$80
                    bcc SKP32768
                    and #$7f
                    jsr SFXDFL
                    lda #$33
                    ldy #$ce
                    jsr ADDEM
                    jmp STRIT

SKP32768            jsr SFXDFL
STRIT               jsr CONVFAC1
                    rts

SGETPTR3            lda GETPTR
                    ldx GETPTR+1
                    sta TEMPI
                    stx $cfee
                    rts

RGETPTR3            lda TEMPI
                    ldx $cfee
                    sta GETPTR
                    stx GETPTR+1
                    rts

BONJOUR             lda #$5f
                    sta DELIM
                    ldx #$11
                    stx FILELEN
                    jsr CHRGOT
                    jsr INPFILE
                    jsr CGRET
BONGET              jsr GET
                    beq BONGET
                    cmp #$8c
                    beq LESAVE
                    jmp READY

LESAVE              lda $0286
                    sta TEMPG
                    lda d021_vBackgCol0
                    sta $0286
                    ldy #$00
                    lda $c2fe
                    sta TEMPJ
                    sty $c2fe
                    lda $c2ff
                    sta $cff0
                    sty $c2ff
                    jsr SAVEEEE2
                    lda TEMPJ
                    sta $c2fe
                    lda $cff0
                    sta $c2ff
                    lda #$93
                    jsr PRINT
                    lda TEMPG
                    sta $0286
                    jmp DS

BLOCK               bf
RENTBLE             8a 9b cb a7 8d 89 20
RENMSGE1                                                2a 2a 20 42
                    41 44 20 4c 49 4e 45 20 52 41 4e 47 45 20 2a 2a
                    20 0d
CONSTANT            00 90 00 00 00 00
NAMESTR             20 20 20 20 20 20 00
TOKTBLE                                                          41
                    44 4a 55 53 54 00 41 55 54 4f 00 43 4f 4c 44 00
                    43 4f 4c 4f 55 52 00 44 45 4c 00 44 53 00 48 45
                    4c 50 00 48 45 58 00 48 55 4e 54 00 4c 4f 4f 4b
                    00 4d 45 4d 00 4d 45 52 47 45 00 4e 00 4f 46 46
                    00 52 45 4e 55 4d 00 53 41 56 45 00 53 45 4e 44
                    00 53 54 41 52 54 00 24 00 2f 00 5e 48 49 00 00
COMMANDS            0d 20 43 4f 4d 4d 41 4e 44 53 20 3a 0d 20 2d 2d
                    2d 2d 2d 2d 2d 2d 2d 2d 20 0d 00
STMSGE                                               11 4d 45 52 47
                    49 4e 47 20 4c 49 4e 45 3a 20 00
CRIGHT                                               1d 1d 1d 1d 1d
                    1d 1d 1d 1d 1d 1d 1d 1d 1d 00
USERSTRG            2c 38 3a 00
REVERSE                                                       12 20
                    20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
                    20 20 92 0d 00
COLTBLE                            90 05 1c 9f 9c 1e 1f 9e 81 95 96
                    97 98 99 9a 9b
OURMSGE                            20 2a 2a 20 49 4e 56 41 4c 49 44
                    20 43 4f 4d 4d 41 4e 44 20 2a 2a 20 0d 00
HELLO                                                         0d 20
                    57 45 44 47 45 2d 36 34 20 28 43 29 31 39 38 33
                    20 44 2e 4d 41 53 4f 4e 20 26 20 41 2e 57 55 4e
                    53 43 48 45 20 0d 20 4d 45 52 47 45 20 41 44 41
                    50 54 45 44 20 46 52 4f 4d 20 42 41 53 49 43 20
                    41 49 44 20 0d 20 50 45 52 4d 49 53 53 49 4f 4e
                    20 54 4f 20 55 53 45 20 42 55 54 20 4e 4f 54 20
                    54 4f 20 53 45 4c 4c 20 0d 00
OFFF                                              0d 20 57 45 44 47
                    45 2d 36 34 20 44 49 53 41 42 4c 45 44 20 0d 00
FILENAME            57 45 44 47 45 2d 36 34 2e 24 43 30 30 30 00 30
                    30 00 59 52 54 59 52 54 59 52 54 59 52 59 2a 00
                    00 00 00 ff 00 00 ff ff 0d f8 01 ee c1 11 ff 0d
                    0d fd 01 f0 c1 50 d0
TOKNUM              14
TEMPX               d0
TEMPY               00
TOKVCTR             b8 cd
FILELEN             11
TEMP8               d0
DELIM               22
STRLEN              05
TEMPA               c0
TEMPB               0a
INCR                00
RENSTART            ff 00
RENGET              00 03
TEMPC               ff 0a
RENENDLN            07 7a
TEMPG               00
TEMPH               7a
TEMPI               d0 ff
TEMPJ                                                            7a
                    d0 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff