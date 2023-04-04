10 OPEN 4,8,1,"obj.w-64.aug19"
100 REM wedge-64
110 REM by darcy mason & alan wunsche
120 :
130 SYS 700:*= $c000:block = *:.opt o4
140 jmp begin:jmp off
150 ;
160 GETptr = $7a
170 synerrOR = $af08
180 chrGET = $0073
190 shIFtkey = $028d
200 cRUNch = $a579
210 chrGOt = $0079
220 PRINT = $ffd2
230 PRINT2 = $e716
240 rREADy = $a474
250 strout = $ab1e
260 STOPkey = $ffe1
270 INPUT = $ffcf
280 talk = $ffb4
290 serin = $ffcf
300 unlsn = $ffae
310 untalk = $ffab
320 SYSLOAD = $e175
330 GET = $ffe4
340 numchar = $b7
350 setlfs = $ffba
360 setnam = $ffbd
370 OPEN = $ffc0
380 chkin = $ffc6
390 st = $90
400 PRINTln = $bdcd
410 CLOSE = $ffc3
420 INTVAL = $14
430 buff = $0200
440 movemem = $a3b8
450 clall = $ffe7
460 rechain = $a533
470 backtext = $a68e
480 comma = $aefd
490 eVALEXP = $ad9e
500 flfxd = $b7f7
510 calladd = $a48c
520 devnp = 128
530 errORex = $a437
535 TOm = $37
540 ;
550 TOknum *=*+1
560 tempx *=*+1
570 tempy *=*+1
580 TOkvctr *=*+2
590 fileLEN *=*+1
600 temp8 *=*+1
610 delim *=*+1
620 ;
630 begin jsr init
640 READy jmp rREADy
650 ;
655 ;
656 ;
660 ;
670 GETch2 inc GETptr:bne NOT0:inc GETptr+1
680 NOT0 jsr chrGOt:stx tempx:sty tempy
690 tsx:lda $0101,x:cmp #<calladd:bne oldGET
700 lda $0102,x:cmp #>calladd:beq GOodcall
710 oldGET ldx tempx:ldy tempy:jmp chrGOt
720 ckauTO jsr auTOln:jmp chrGOt
730 GOodcall jsr chrGOt:bcc ckauTO
740 ;
750 ;
760 cmp #">":bne oldGET
770 jsr chrGET:pla:pla
780 ;
790 ; check FOR VALid commANDs
800 ;
810 ldx #0:stx TOknum
820 userTOk ldy #0
830 TOkloop lda TOktble,x:beq GOodTOk:cmp (GETptr),y
840 bne NEXTTOk:inx:iny:bne TOkloop
850 ;
860 NEXTTOk inx:lda TOktble,x:bne NEXTTOk:inx:inc TOknum
870 lda TOktble,x:beq serrOR2:bne userTOk
880 ;
890 serrOR2 jmp ourerr
900 ;
910 ;
920 GOodTOk jsr update
930 lda TOknum:asl:tax:lda TOkadd,x:sta TOkvctr:lda TOkadd+1,x
940 sta TOkvctr+1
950 jsr chrGOt:jmp (TOkvctr)
960 ;
970 ;
980 TOktble .ASC "adjust":.byte 0
990 .ASC "auto":.byte 0
1000 .ASC "cold":.byte 0
1010 .ASC "colour":.byte 0
1020 .ASC "del":.byte 0
1030 .ASC "ds":.byte 0
1040 .ASC "help":.byte 0
1050 .ASC "hex":.byte 0
1060 .ASC "hunt":.byte 0
1070 .ASC "look":.byte 0
1075 .ASC "mem":.byte 0
1080 .ASC "merge":.byte 0
1090 .ASC "n":.byte 0
1100 .ASC "off":.byte 0
1110 .ASC "renum":.byte 0
1120 .ASC "save":.byte 0
1130 .ASC "send":.byte 0
1140 ;.ASC "start".byte 0
1150 .ASC "$":.byte 0
1160 .ASC "/":.byte 0
1170 .ASC "^hi":.byte 0
1180 .byte 0
1190 ;
1200 TOkadd .wORd adjust
1210 .wORd auTO
1220 .wORd cold
1230 .wORd col
1240 .wORd del
1250 .wORd ds
1260 .wORd help
1270 .wORd hex
1280 .wORd hunt
1290 .wORd dump
1295 .wORd memORy
1300 .wORd merge
1310 .wORd name
1320 .wORd off
1330 .wORd renum
1340 .wORd SAVEm
1350 .wORd sEND
1360 ;.wORd start
1370 .wORd disk
1380 .wORd LOAD
1390 .wORd bONjour
1400 ;
1410 commANDs .byte 13:.ASC " commands :{space*3}":.byte 13
1420 .ASC " {-*10}{space*3}":.byte 13,0
1430 ;
1440 ;
1450 merge ldx #17:stx fileLEN:jsr inpfile
1460 ;
1470 jsr strtmsge
1480 lda #2:ldx #8:ldy #0:jsr OPENfile
1490 CONT1 ldx #2:jsr chkin
1500 ldx #0
1510 jsr GETchr:jsr GETchr ;LOAD address
1520 lnloop jsr GETchr:jsr GETchr ;link
1530 cmp #0:bne CONT2
1540 jmp pgmover
1550 CONT2 jsr GETln
1560 ;
1570 ;put the line in
1580 jsr putin
1590 jmp lnloop
1600 ;
1610 pgmover jsr cgret
1620 jmp ds
1630 ;
1640 ; GET a basic line
1650 ;
1660 GETln ldx #255:jsr GETchr
1670 sta INTVAL:jsr GETchr:sta INTVAL+1
1680 stx tempx:lda INTVAL+1:ldx INTVAL:jsr PRINTln:jsr cgret
1690 lda #"{up}":jsr PRINT:lda #<cright:ldy #>cright:jsr strout
1700 ldx tempx
1710 ll5 inx:cpx #$4e:bcs ll4
1720 jsr GETchr:sta buff,x:cmp #0:bne ll5
1730 ll4 inx:inx
1740 sta buff,x
1750 inx:inx:inx
1760 stx $0b      ; buff ptr
1770 rts
1780 ;
1790 serrOR lda #34:sta delim:jmp synerrOR
1800 inpfile ldx #0:ldy #0
1810 cmp delim:bne serrOR
1820 fileloop cpx fileLEN:beq strerr:jsr chrGET2:beq namedONe
1830 cmp delim:beq namedON
1840 sta fiLEName,x:inx:bne fileloop
1850 namedON iny
1860 namedONe cpx #0:beq serrOR:stx numchar:lda #0:sta fiLEName,x
1870 jsr update
1880 ldx #<fiLEName:ldy #>fiLEName
1890 lda numchar:jsr setnam
1900 lda #34:sta delim:jmp chrGOt
1910 ; string TOo lONg message
1920 strerr lda #34:sta delim:ldx #23:jmp errORex
1930 ;
1940 fiLEName *= *+50
1950 ;
1960 ; errOR routines
1970 ;
1980 sterrOR cpy #64:bne CONTt:jmp pgmover
1990 CONTt jmp ds
2000 ;
2010 GETchr jsr INPUT:ldy st:bne sterrOR
2020 rts
2030 strtmsge lda #<stmsge:ldy #>stmsge
2040 jmp strout
2050 stmsge .ASC "{down}merging line: "
2060 .byte 0
2070 cright .ASC "{right*14}"
2080 .byte 0
2090 chrGET2 iny:lda (GETptr),y:rts
2100 ;
2110 ;
2120 LOAD ldx #17:stx fileLEN:jsr inpfile
2130 lda #1:ldx #8:ldy #1
2140 jsr setlfs
2150 lda #0:sta $0a:jmp SYSLOAD
2160 ;
2170 ds lda #1:jsr CLOSE:lda #2:jsr CLOSE:jsr clall
2180 lda #32:jsr PRINT
2190 lda #0:jsr setnam:jsr OPENcc
2200 ldx #1:jsr chkin
2210 dsloop jsr INPUT:jsr PRINT:cmp #13:bne dsloop:lda #" ":jsr PRINT2
2220 lda #1:jsr CLOSE:jsr clall:jmp READy
2230 ;
2240 off lda #<offf:ldy #>offf:jsr strout:jsr resGETt:jmp READy
2250 ;
2260 resGETt ldx #2:resGET lda SAVEtble,x:sta chrGET,x
2270 lda #0:sta SAVEtble,x:dex
2280 bpl resGET:rts
2290 ;
2300 start ldx #17:stx fileLEN:jsr inpfile
2310 lda #2:ldx #8:ldy #$0:jsr OPENfile
2315 ldx #2:jsr chkin
2320 jsr INPUT; LOAD address lo-byte
2325 jsr timer
2330 tax:stx tempx:jsr INPUT; hi-byte
2335 jsr timer
2340 sta tempy:lda #2:jsr CLOSE:jsr clall
2350 lda #"$":jsr PRINT
2360 lda tempy:ldx tempx:jsr PRINTadd
2370 jsr space:jsr PRINT
2380 lda tempy:ldx tempx:jsr PRINTln
2390 jsr space
2400 jsr cgret:jmp ds
2405 timer ldy #100:timeloop dey:bne timeloop:rts
2410 ;
2420 sEND ldx #80:stx fileLEN:jsr inpfile
2430 jsr OPENcc:jmp ds
2440 ;
2450 help lda #<commANDs:ldy #>commANDs:jsr strout
2460 ldy #0
2470 label lda TOktble,y:cmp #"^":beq END2:jsr space:lda #">"
2480 jsr PRINT:helploop lda TOktble,y
2490 beq END1
2500 NOTuparr jsr PRINT:iny:bne helploop
2510 END1 jsr cgret
2520 END3 iny:lda TOktble,y
2530 bne label
2540 jmp READy
2550 END2 iny:lda TOktble,y:bne END2:jmp END3
2560 ;
2570 ; initialize
2575 ;
2576 init lda #>block:cmp #$a0:bcs overit
2577 sta TOm+1:lda #<block:sta TOm:jsr NEW
2579 ;
2580 overit lda #0:sta incr:lda #34:sta delim
2590 lda #6:sta 53280:sta 53281:lda #3:sta 646
2600 ldx #2:lda SAVEtble,x:bne helloo
2610 ldx #2:SAVEGET lda chrGET,x:sta SAVEtble,x:dex:bpl SAVEGET
2620 ldx #2:initGET lda GETtble,x:sta chrGET,x:dex:bpl initGET
2630 helloo lda #<hello:ldy #>hello:jmp strout
2640 ;
2650 SAVEtble .byte 0,0,0,0
2660 GETtble .byte $4c
2670 .wORd GETch2
2680 ourerr lda #<ourmsge:ldy #>ourmsge
2690 jsr strout:jmp READy
2700 ;
2710 ourmsge .ASC " ** invalid wedge command ** ":.byte 13,0
2720 hello .byte 13:.ASC " wedge-64 (c)1983 d.mason & a.wunsche ":.byte 13
2730 .ASC " merge adapted from basic aid ":.byte 13
2740 .ASC " permission to use but not to sell ":.byte 13,0
2750 offf .byte 13:.ASC " wedge-64 disabled ":.byte 13,0
2760 ;
2770 ;
2780 OPENcc lda #1:ldx #8:ldy #15:OPENfile jsr setlfs
2790 jsr OPEN; commAND channel OPEN !
2800 ldy st
2810 beq OPENed
2820 cmp #devnp:bne jumpds:ldx #5:jmp errORex:jumpds jmp ds
2830 OPENed rts
2840 ;
2850 ;
2860 PRINTnib clc:adc #$f6:bcc add2
2870 adc #$06:add2 adc #$3a:jmp PRINT
2880 ;
2890 PRINTbyt pha:lsr:lsr:lsr:lsr:jsr PRINTnib
2900 pla:AND #$0f:jmp PRINTnib
2910 ;
2920 PRINTadd jsr PRINTbyt:txa:jmp PRINTbyt
2930 ;
2940 ourOPEN jsr OPEN:ldy st:beq okst:jmp ds
2950 okst rts
2960 ;
2970 ;
2980 hex cmp #"$":beq hex2:jsr eVALEXP:jsr flfxd
2990 jsr space:lda #"$":jsr PRINT:
3000 ldx INTVAL:lda INTVAL+1
3010 jsr PRINTadd
3020 hexEND jsr space:jsr cgret:jmp READy
3030 ;
3040 hex2 jsr inpadd
3050 sta tempx:jsr space:txa:ldx tempx:jsr PRINTln
3060 jmp hexEND
3070 ;
3080 disk sta fiLEName+1
3090 ldy #255:lda #"$":sta fiLEName
3100 catloop2 sty temp8:jsr chrGET2:ldy temp8:sta fiLEName+2,y:cmp #$00
3110 beq cnameok2:iny:cpy #49:bne catloop2:jmp strerr
3120 cnameok2 iny:iny:sty numchar:iny:lda #0:sta fiLEName+2,y:lda #1:ldx #8
3130 ldy #$60
3140 jsr setlfs:jsr cgret
3150 jsr unlsn:jsr untalk:lda numchar:ldx #<fiLEName:ldy #>fiLEName
3160 jsr setnam:jsr OPEN:ldx #1:jsr chkin
3170 jsr serin:jsr serin;  ignORe LOAD address
3180 GETlink2 jsr serin:jsr serin:ldx st:bne catdONe ; ignORe link
3190 lda #32:jsr PRINT2
3200 jsr serin:tax:jsr serin:jsr PRINTln   ; PRINT pgm  # blocks
3210 lda #" ":jsr PRINT2:jsr PRINT2:jsr PRINT2:jsr PRINT2
3220 dirloop2 jsr serin:jsr PRINT2:bne dirloop2
3230 lda #13:jsr PRINT2:jmp GETlink3
3240 ;
3250 catdONe jsr untalk:jsr cgret:jsr PRINT
3260 jmp ds
3270 ;
3280 GETlink3 jsr serin:jsr serin:ldx st:bne catdONe ; ignORe link
3290 lda #32:jsr PRINT2
3300 jsr serin:tax:jsr serin:jsr PRINTln   ; PRINT pgm  # blocks
3310 lda #32:jsr PRINT2
3320 dirloop3 jsr serin:jsr PRINT2:beq catdONe:cmp #34:bne dirloop3
3330 ldy #18
3340 calnloop jsr serin:cmp #0:beq catdONe:jsr PRINT2:dey:bne calnloop
3350 lda #" ":jsr PRINT2:jsr PRINT2
3360 lda #":":jsr PRINT
3370 calnlp2 jsr serin:jsr PRINT2:bne calnlp2
3380 jsr STOPshft:beq catdONe
3390 lda #13:jsr PRINT2:jmp GETlink3
3400 ;
3410 name cmp #34:beq username
3420 lda #<namestr:ldy #>namestr:jsr strout
3430 ;
3440 lda #34:jsr PRINT
3450 lda #<fiLEName:ldy #>fiLEName:jsr strout
3460 lda #34:jsr PRINT:lda #",":jsr PRINT:lda #"8":jsr PRINT:lda #":":
3470 jsr PRINT:jsr cgret:lda #"{up}":jsr PRINT
3480 ldx #$ff:txs:jmp rREADy+12
3490 namestr .ASC "{space*8}":.byte 0
3500 ;
3510 username ldx #70:stx fileLEN:jsr inpfile:jmp READy
3520 inpadd lda #0:sta tempy:tay:jsr inpbyte
3530 tax:stx temp8:lda #0:sta tempy
3540 inpbyte jsr inpnib
3550 asl:asl:asl:asl
3560 sta tempy
3570 inpnib jsr chrGET2
3580 cmp #"0":bcc serrOR3
3590 cmp #":":bcc o9
3600 cmp #"a":bcc serrOR3
3610 cmp #"g":bcs serrOR3
3620 sbc #$06
3630 o9 AND #$0f
3640 ORa tempy
3650 ldx temp8
3660 rts
3670 serrOR3 jmp synerrOR
3680 cold lda #0:ldx #2:coldloop sta SAVEtble,x:dex:bpl coldloop:jmp 64738
4000 space lda #" ":jmp PRINT
4010 cgret lda #13:jmp PRINT
50000 .file 8,"w-64+.e6"
