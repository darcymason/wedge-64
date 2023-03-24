
start tok64 w-64p.e6
100 ;
110 ; w-64+ - file#2
120 ;
130 varstart = $2d:SAVEprog = $e15f
140 starray = $2f
150 LOADfac1 = $bba2
160 cONvfac1 = $bddd
170 varptr = $5f
180 strptr = $fd
190 ENDptr = $26
200 inpfxd = $a96b
210 findln = $a613
220 illqty = $b248
230 rechnptr = $22
240 moveTO = $fd
250 movefrom = $26
260 sfxdfl = $b391
270 keyb = 631
280 keybLEN = 198
290 foundnum = $a49f:startb = $2b
300 ;
310 strLEN *= *+1
320 tempa *= *+1:tempb *= *+1
330 incr *= *+1
340 ;
350 fini jmp READy
360 dump lda varstart:ldx varstart+1
370 sta varptr:stx varptr+1:jmp GETvar
380 ;
390 NEXTvar jsr STOPshft:beq fini:lda #13:jsr PRINT
400 lda #7:clc:adc varptr:sta varptr
410 lda varptr+1:adc #0:sta varptr+1
420 ;
430 GETvar lda #"{sh space}":jsr PRINT:lda varptr+1
440 cmp starray+1:bcc dumpok
450 bne fini
460 lda varptr
470 cmp starray:bcs fini
480 ;
490 dumpok ldy #0:lda (varptr),y
500 bpl NOTINT
510 jmp INTeger
520 NOTINT jsr PRINT
530 jsr incptr
540 cmp #$80
550 bcs string
560 floating jsr PRINT:jsr equals:lda #"{left}":jsr PRINT
570 jsr incptr
580 tya:clc:adc varptr:sta tempx:lda varptr+1:adc #0:sta tempy
590 lda tempx:ldy tempy:jsr LOADfac1
600 jsr cONvfac1
610 jsr strout
620 jmp NEXTvar
630 ;
640 string AND #$7f:jsr PRINT:lda #"$":jsr PRINT
650 jsr equals:lda #34:jsr PRINT
660 jsr incptr:sta strLEN
670 jsr incptr:sta strptr
680 jsr incptr:sta strptr+1
690 ldy strLEN:beq quote
700 ldy #0:prloop lda (strptr),y
710 jsr PRINT:iny:cpy strLEN:bne prloop
720 quote lda #34:jsr PRINT
730 jmp NEXTvar
740 ;
750 INTeger AND #$7f:jsr PRINT
760 jsr incptr:AND #$7f:jsr PRINT
770 lda #"%":jsr PRINT:jsr equals
780 jsr incptr:sta tempa ; GET hi byte
790 ; has high bit set IF neg've
800 bpl plus
810 lda #"-":jsr PRINT
820 lda tempa:eOR #$ff:clc:adc #0
830 pha:jsr incptr:eOR #$ff:tax:inx:bne pull:pla:clc:adc #1:jmp PRINTit
840 pull pla:jmp PRINTit
850 plus lda tempa:AND #$7f
860 pha:jsr incptr
870 tax
880 pla
890 PRINTit jsr PRINTln
900 jmp NEXTvar
910 ;
920 incptr iny:lda (varptr),y
930 rts
940 equals lda #" ":tax:jsr PRINT:lda #"=":jsr PRINT:txa
950 jmp PRINT
960 ;
970 ;  h u n t
980 ;
990 hunt jsr cRUNch:jsr chrGET:ldx #80:stx fileLEN
1000 sta delim:jsr inpfile
1010 ;
1020 beq ONlydl
1030 jsr comma
1040 ONlydl jsr lnrange
1050 ;
1060 ldy strptr:ldx strptr+1:sty INTVAL:stx INTVAL+1
1070 lda #4:clc:adc numchar:sta numchar
1080 jsr findln
1090 ;
1100 NEWline jsr STOPshft:beq allGOne
1110 ldy #1:lda (varptr),y  ;hb link
1120 beq allGOne
1130 ;
1140 iny:lda (varptr),y
1150 sta INTVAL          ; GET ln#
1160 iny:lda (varptr),y
1170 sta INTVAL+1
1180 ;
1190 lda INTVAL+1
1200 cmp ENDptr+1
1210 bcc huntloop     ;check hb
1220 bne allGOne
1230 ;
1240 lda INTVAL
1250 cmp ENDptr
1260 beq huntloop     ;check lb
1270 bcs allGOne
1280 ;
1290 huntloop ldy #4
1300 keeptry lda (varptr),y
1310 beq NEXTline
1320 cmp fiLEName-4,y
1330 beq oksofar
1340 ;
1350 inc varptr
1360 bne okkkk
1370 inc varptr+1
1380 okkkk jmp huntloop
1390 ;
1400 oksofar iny   ;GOod chr->GET NEXT
1410 cpy numchar
1420 bne keeptry
1430 ;
1440 jsr findln:jsr prline   ;binGO!
1450 ;
1460 ;
1470 NEXTline tya:sec
1480 adc varptr        ;update ptr TO
1490 sta varptr
1500 bcc NEWline       ;NEXT line
1510 inc varptr+1
1520 jmp NEWline
1530 ;
1540 allGOne jmp READy
1550 ;
1560 prline ldy #1:lda #" ":jsr PRINT
1570 sty $0f
1580 lda (varptr),y
1590 beq lab1
1600 jsr $aad7
1610 iny:lda (varptr),y
1620 tax
1630 iny:lda (varptr),y
1640 sty $49
1650 jsr PRINTln
1660 lda #" "
1670 lab8 ldy $49
1680 AND #$7f
1690 lab4 jsr $ab47
1700 cmp #$22
1710 bne lab2
1720 lda $0f
1730 eOR #$ff
1740 sta $0f
1750 ;
1760 lab2 iny
1770 beq lab1
1780 lda (varptr),y
1790 bne lab3
1800 ;
1810 lab1 rts        ;all dONe!
1820 ;
1830 lab3 bpl lab4
1840 cmp #$ff
1850 beq lab4
1860 bit $0f
1870 bmi lab4
1880 ;
1890 sec:sbc #$7f
1900 tax
1910 sty $49
1920 ldy #$ff
1930 lab7 dex
1940 beq lab5
1950 ;
1960 lab6 iny:lda $a09e,y
1970 bpl lab6
1980 bmi lab7
1990 ;
2000 lab5 iny:lda $a09e,y
2010 bmi lab8
2020 jsr $ab47
2030 bne lab5
2040 ;
2050 STOPshft jsr STOPkey
2060 beq GOback
2070 shIFTOn lda shIFtkey
2080 cmp #1
2090 beq shIFTOn
2100 GOback rts
2110 ;
2120 illegal jmp illqty
2130 ;
2140 col beq READyyyy:jsr GETfxd:bne illegal
2150 sta 53280
2160 jsr comma
2170 jsr GETfxd:bne illegal
2180 sta 53281
2190 jsr comma
2200 jsr GETfxd:bne illegal
2210 sta 646
2220 READyyyy jmp READy
2230 ;
2240 ;
2250 ;
2260 TOobig jmp illqty
2270 auTO jsr GETfxd
2280 bne TOobig
2290 sta incr:jmp READy
2300 ;
2310 ;
2320 auTOln jsr inpfxd:ldy incr:beq GOback4
2330 jsr chrGOt:beq GOback4
2340 lda incr
2350 clc:adc INTVAL:tay:lda INTVAL+1:adc #0
2360 jsr fxdfl
2370 ldx #0:keybloop lda $0101,x:beq keybdONe:sta keyb,x:inx:bne keybloop
2380 keybdONe inx
2390 lda #" ":sta keyb,x
2400 inx:stx keybLEN
2410 GOback4 jmp foundnum
2420 ;
2430 del beq READyy
2440 jsr cRUNch:jsr chrGET:jsr lnrange
2450 lda strptr:ldx strptr+1
2460 sta INTVAL:stx INTVAL+1
2470 jsr findln
2480 lda varptr:ldx varptr+1
2490 sta moveTO:stx moveTO+1
2500 ldx ENDptr:ldy ENDptr+1
2510 inx:bne sTOre:iny:sTOre stx INTVAL:sty INTVAL+1
2520 jsr findln:lda varptr:ldx varptr+1:sta movefrom:stx movefrom+1
2530 ;
2540 jsr delmem
2550 jsr rechain
2560 lda rechnptr:clc:adc #2:sta varstart
2570 lda rechnptr+1:adc #0:sta varstart+1
2580 jsr NEW
2590 READyy jmp READy
2600 ;
2610 ;
2620 ;
2630 lnrange ldy #$ff
2640 sty ENDptr+1
2650 iny:sty ENDptr:sty strptr:sty strptr+1
2660 jsr chrGOt:beq GOback2
2670 bcc par1
2680 cmp #$ab:bne lastlbl
2690 jsr chrGET:bcs badpar:jmp par2
2700 ;
2710 badpar jmp synerrOR
2720 ;
2730 par1 jsr inpfxd
2740 lda INTVAL:ldx INTVAL+1
2750 sta strptr:stx strptr+1
2760 jsr chrGOt:cmp #$ab:bne badpar
2770 jsr chrGET:beq GOback2
2780 bcc par2
2790 GOback2 rts
2795 lastlbl jmp synerrOR
2800 ;
2810 par2 jsr inpfxd
2820 lda INTVAL:ldx INTVAL+1
2830 sta ENDptr:stx ENDptr+1
2840 jmp chrGOt
2850 delmem ldy #0
2860 delloop lda movefrom+1:cmp varstart+1
2870 bcc startdel
2880 bne deldONe
2890 lda movefrom:cmp varstart
2900 bcs deldONe
2910 ;
2920 startdel lda (movefrom),y
2930 sta (moveTO),y
2940 inc movefrom:bne xxx
2950 inc movefrom+1
2960 xxx inc moveTO:bne yyy
2970 inc moveTO+1
2980 yyy bne delloop
2990 ;
3000 ;
3010 deldONe rts
3020 ;
3030 ;
3040 sGETptr lda GETptr:ldx GETptr+1
3050 sta varptr:stx varptr+1
3060 rts
3070 ;
3080 rGETptr lda varptr:ldx varptr+1
3090 sta GETptr:stx GETptr+1
3100 rts
3110 ;
3120 SAVEm jsr SAVEee:jmp ds
3130 ;
3140 SAVEee ldx #17:stx fileLEN
3150 jsr inpfile
3160 SAVEee2 lda #1:ldx #8:tay:jsr setlfs
3170 ;
3180 jsr chrGOt:cmp #",":beq mlSAVE
3190 lda #startb:ldx varstart
3200 ldy varstart+1
3210 SAVEit jsr SAVEprog:lda #13:jmp PRINT
3220 ;
3240 ;
3250 mlSAVE jsr inpadd
3260 sta strptr:stx strptr+1
3270 jsr update:jsr chrGET
3280 cmp #",":bne mlserr
3290 jsr inpadd
3300 stx tempx:tax:jsr update:ldy tempx
3310 lda #strptr
3320 jmp SAVEit
3330 ;
3340 mlserr jmp synerrOR
3350 ;
3360 adjust ldx #0:lda 646:sta tempa
3370 colloop stx tempb:lda coltble,x:jsr PRINT:lda #<reverse:ldy #>reverse
3380 jsr strout:ldx tempb:inx:cpx #16:bne colloop
3390 lda tempa:sta 646
3400 lda #13:ldx #5:retloop jsr PRINT:dex:bne retloop
3410 jmp READy
3420 ;
3430 reverse .ASC "{reverse on}{space*20}{reverse off}"
3440 .byte 13,0
3450 coltble .ASC "{black}{white}{red}{cyan}{156}{green}{blue}{yellow}{orange}{brown}{pink}{dark gray}{gray}{light green}{light blue}{light gray}"
3460 ;
3470 update tya:clc:adc GETptr:sta GETptr:lda GETptr+1:adc #0:sta GETptr+1
3480 rts
50000 .file 8,"w-64{pound}.e6"
stop tok64
(bastext 1.0)
