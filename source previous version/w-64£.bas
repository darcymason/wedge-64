
start tok64 w-64pnd.e6
100 ;
110 ; w-64.{pound} file#3
120 ;
130 ;
140 renstart *= *+2
150 rentemp = $8d:reninc = $28
160 multflag = $2a:rencount = $8b
170 ;
180 renGET *= *+2
190 tempc *= *+2
200 renENDln *= *+2
210 qumode = $08
220 tempg *= *+1:temph *= *+1
230 tempi *= *+2:tempj *= *+2
250 cntptr = $19
260 memfac2 = $ba8c
270 addem = $b867; add fac2 TO fac1
280 strfac = $bcf3
290 ;
300 ;
310 renum jsr cRUNch:jsr chrGET:lda #10:sta reninc
320 lda #100:sta renstart
330 lda #0:sta renstart+1
340 jsr chrGOt
350 beq rENDef
360 jsr GETfxd
370 sta renstart:stx renstart+1
380 ;
390 jsr comma
400 jsr GETfxd:beq okinc
405 jmp illqty
410 okinc sta reninc
420 ;
430 jsr chrGOt:beq rENDef
440 jsr comma
450 ;
460 rENDef jsr lnrange
470 ;
480 lda renstart:ldx renstart+1
490 sta INTVAL:stx INTVAL+1
500 jsr findln
510 ldy #3:lda (varptr),y:cmp strptr+1:bcc rangebad:bcs youbet:dey
520 lda (varptr),y:cmp strptr:bcc rangebad
530 youbet lda strptr:ldx strptr+1
540 sta INTVAL:stx INTVAL+1
550 jsr findln
560 lda varptr:ldx varptr+1
570 sta renGET:stx renGET+1
580 ;
590 lda ENDptr:ldx ENDptr+1
600 sta renENDln:stx renENDln+1
610 sta INTVAL:stx INTVAL+1
620 inc INTVAL:bne stcount
630 inc INTVAL+1
640 stcount jsr countem
650 ;
660 jsr mult
670 lda rentemp+1:cmp #$fa:bcc rangeok
680 rangebad lda #<renmsge1:ldy #>renmsge1:jsr strout:jmp READy
690 ;
700 rangeok jsr findln:jsr rGETptr
710 ldy #1:lda (GETptr),y:beq themeat
720 ldy #3:lda rentemp+1:cmp (GETptr),y:bcc themeat
730 bne rangebad
740 lda rentemp:dey:cmp (GETptr),y:bcs rangebad
750 themeat lda startb:ldx startb+1
760 sta GETptr:stx GETptr+1
770 ;
780 ; pass1
790 ;
800 resetqu ldy #0:sty qumode
810 linklopp ldy #1:lda (GETptr),y:bne linkok
820 rENDONe1 jmp pass2
830 ;
840 linkok iny:lda (GETptr),y:sta INTVAL:iny:lda (GETptr),y:sta INTVAL+1
850 ldy #4:jsr update:jsr sGETptr3:ldy #$ff
860 aloop iny:aloop2 lda (GETptr),y:beq rlndONe
870 cmp #34:beq qufound
880 ldx qumode:bne aloop
890 ldx #6:tablelop cmp rentble-1,x:beq renbinGO
900 dex:bne tablelop
910 beq aloop
920 ;
930 qufound lda qumode:eOR #$ff:sta qumode
940 jmp aloop
950 ;
960 rlndONe iny:jsr update:jmp resetqu
970 ;
980 renbinGO pha:jsr update:pla
985 cmp #$cb:bne renbing2:jsr chrGET
986 cmp #$a4:bne aloop2
990 renbing2 jsr chrGET:bcs aloop2
1000 ;
1010 jsr SINtVAL:jsr sGETptr2:jsr chrGOt:jsr strfac:jsr flfxd
1020 ;
1030 jsr ckrange:beq needchng
1040 jmp afternum
1050 ;
1060 ;
1070 needchng lda INTVAL:ldx INTVAL+1
1080 sta renENDln:stx renENDln+1
1090 jsr countem:beq somelab:lda #$ff:sta rencount:sta rencount+1
1100 somelab jsr space
1110 ;
1120 jsr mult
1130 ldx rentemp:lda rentemp+1
1140 stx INTVAL:sta INTVAL+1
1150 jsr PRINTln
1160 ldy rentemp:lda rentemp+1:jsr fxdfl
1170 ;
1180 jsr rGETptr3:ldx #$ff
1190 ;
1200 doitloop ldy #0:inx
1210 lda GETptr+1:cmp tempc+1
1220 bcc noprob2:bne dONethis
1230 lda GETptr:cmp tempc
1240 bcs dONethis
1250 noprob2 lda (GETptr),y:sta buff,x:iny
1260 jsr update:jmp doitloop
1270 dONethis ldy #0:lda $0100:cmp #"-":bne bigloop:sta buff,x:inx
1280 bigloop lda $0101,y:beq dONept2:sta buff,x:iny:inx:bne bigloop
1290 dONept2 stx temph:jsr rGETptr2:jsr chrGOt:jsr strfac:jsr chrGOt
1300 ldx temph:ldy #0:big2loop cmp #0:sta buff,x:beq dONept3
1310 inx:iny:lda (GETptr),y:jmp big2loop
1320 ;
1330 dONept3 inx:inx:sta buff,x:inx:inx:inx:stx $0b
1340 jsr rINTVAL:jsr putin
1350 jsr rGETptr2:jsr strfac
1360 lda strptr:ldx strptr+1
1370 sta INTVAL:stx INTVAL+1
1380 jsr findln:lda varptr:ldx varptr+1
1390 sta renGET:stx renGET+1
1400 ;
1410 afternum jsr rINTVAL
1420 ;
1430 jsr chrGOt:cmp #",":beq GETNEXT1
1440 cmp #$ab:beq GETNEXT1
1450 ldy #0:sty qumode:jmp aloop2
1460 ;
1470 GETNEXT1 jmp renbing2
1480 ;
1490 ;
1500 ;
1510 GETfxd jsr inpfxd:GETINT lda INTVAL
1520 ldx INTVAL+1:rts
1530 ;
1540 ;
1550 mult lda reninc:sta tempg:lda renstart:ldx renstart+1
1560 sta rentemp:stx rentemp+1
1570 lda #0:sta multflag
1580 ;
1590 ldx #8
1600 multloop lsr reninc
1610 bcc dONtadd
1620 lda multflag:bne multerr
1630 lda rencount
1640 clc:adc rentemp
1650 sta rentemp
1660 lda rencount+1
1670 adc rentemp+1
1680 sta rentemp+1
1690 ;
1700 dONtadd asl rencount
1710 rol rencount+1
1720 rol multflag
1730 dex
1740 bne multloop
1750 ;
1760 lda tempg:sta reninc
1770 rts
1780 multerr lda #$ff
1790 sta rentemp:sta rentemp+1:lda tempg:sta reninc
1800 rts
1810 ;
1820 pass2 lda renGET:ldx renGET+1
1830 ;
1840 sta GETptr:stx GETptr+1
1850 pass2lp ldy #1:lda (GETptr),y:beq pass2dn
1860 ldy #3:lda (GETptr),y
1870 cmp ENDptr+1:bcc noprob:bne pass2dn
1880 dey:lda (GETptr),y
1890 cmp ENDptr:bcc noprob:bne pass2dn
1900 ;
1910 noprob ldy #2:lda renstart
1920 sta (GETptr),y
1930 iny:lda renstart+1
1940 sta (GETptr),y
1950 ;
1960 ldy #0:lda (GETptr),y:tax
1970 iny:lda (GETptr),y
1980 sta GETptr+1:stx GETptr
1990 lda reninc
2000 clc:adc renstart:sta renstart
2010 bcc pass2lp
2020 lda renstart+1:adc #0:sta renstart+1
2030 jmp pass2lp
2040 ;
2050 pass2dn jmp READy
2060 ;
2070 ;
2080 serrOR9 jmp serrOR
2090 ;
2100 memORy dec GETptr:lda GETptr:cmp #$ff:bne nosubt
2110 dec GETptr+1
2120 nosubt jsr inpadd
2130 sta strptr:stx strptr+1
2140 jsr update:jsr chrGET:cmp #",":bne serrOR9
2150 jsr inpadd
2160 sta ENDptr:stx ENDptr+1
2170 ;
2180 jsr cgret
2190 lloopp jsr STOPshft:beq pass2dn
2200 lda strptr+1:cmp #>block:bcc LETem1
2210 lda #>block:clc:adc #$10:sta temph:ldy strptr+1:cpy temph:bcs LETem1
2220 ;
2230 jmp READy
2240 ;
2250 LETem1 lda #".":jsr PRINT
2260 lda strptr+1:ldx strptr
2270 jsr PRINTadd
2280 ldy #0
2290 PRINTmOR jsr space
2300 lda (strptr),y
2360 sty temph:jsr PRINTbyt:ldy temph
2370 iny:cpy #8:bne PRINTmOR
2380 jsr space
2390 lda #"{reverse on}":jsr PRINT
2400 ldy #0
2410 bytloop lda (strptr),y
2420 ldx #0:stx qumode
2421 cmp #161:bcs ookk
2422 cmp #32:bcc NOTookk
2423 cmp #128:bcc ookk
2424 NOTookk lda #$2e
2429 ookk jsr PRINT
2430 iny:cpy #8:bne bytloop
2440 ;
2450 tya:clc:adc strptr:sta strptr
2460 lda strptr+1:adc #0:sta strptr+1
2470 jsr cgret
2480 ;
2560 ;
2570 lda strptr+1:cmp ENDptr+1:bcc GOlloopp
2580 bne nolloopp
2590 ;
2600 lda strptr:cmp ENDptr:bcc GOlloopp
2610 bne nolloopp
2620 ;
2630 GOlloopp jmp lloopp
2640 nolloopp jmp READy
2650 ;
2660 ;put the line in
2670 putin jsr $a613    ; find basic line
2680 bcc l1
2690 ldy #1:lda ($5f),y
2700 sta $23:lda $2d:sta $22
2710 lda $60:sta $25:lda $5f
2720 dey:sbc ($5f),y
2730 clc:adc $2d
2740 sta $2d:sta $24
2750 lda $2e:adc #$ff
2760 sta $2e:sbc $60
2770 tax
2780 sec:lda $5f
2790 sbc $2d:tay
2800 bcs l2
2810 inx:dec $25
2820 l2 clc:adc $22
2830 bcc l3
2840 dec $23:clc
2850 l3 lda ($22),y
2860 sta ($24),y
2870 iny:bne l3
2880 inc $23:inc $25
2890 dex:bne l3
2900 l1 jsr backtext:jsr NEW ; under [ NEW ]
2910 jsr rechain
2920 lda buff
2930 beq retrn
2940 clc:lda $2d
2950 sta $5a:adc $0b
2960 sta $58:ldy $2e
2970 sty $5b
2980 bcc l4
2990 iny
3000 l4 sty $59
3010 jsr movemem ; move memORy
3020 lda INTVAL:ldy INTVAL+1
3030 sta $01fe:sty $01ff
3040 lda $31:ldy $32  ;END basic
3050 sta $2d:sty $2e  ;start basic vars
3060 ldy $0b
3070 dey
3080 l5 lda $01fc,y:sta ($5f),y
3090 dey:bpl l5
3100 jsr backtext:jsr NEW ; under [ NEW ]
3110 jsr rechain
3120 ;
3130 retrn rts
3140 ;
3150 NEW lda $37:ldy $38
3160 sta $33:sty $34
3170 lda $2d:ldy $2e
3180 sta $2f:sty $30
3190 sta $31:sty $32
3200 jsr $a81d
3210 ldx #$19:stx $16
3220 lda #0:sta $3e:sta $10
3230 rts
3240 ;
3250 countem lda renGET:ldx renGET+1
3260 sta cntptr:stx cntptr+1
3270 ldy #0:sty rencount:sty rencount+1
3280 ;
3290 countlp ldy #1:lda (cntptr),y
3300 bne cntnover:lda #1:rts
3310 ;
3320 cntnover ldy #3:lda (cntptr),y
3330 cmp renENDln+1
3340 bcc cnTOn
3350 bne cntdONe
3360 dey:lda (cntptr),y
3370 cmp renENDln
3380 bcc cnTOn
3390 ;
3400 cntdONe rts
3410 ;
3420 cnTOn ldy #0
3430 lda (cntptr),y:tax
3440 iny:lda (cntptr),y:sta cntptr+1:stx cntptr
3450 inc rencount:bne countlp
3460 inc rencount+1:bne countlp
3470 ;
3480 SINtVAL lda INTVAL:ldx INTVAL+1
3490 sta tempa:stx tempb
3500 rts
3510 ;
3520 rINTVAL lda tempa:ldx tempb
3530 sta INTVAL:stx INTVAL+1
3540 rts
3550 ;
3560 sGETptr2 lda GETptr:ldx GETptr+1
3570 sta tempc:stx tempc+1
3580 rts
3590 ;
3600 rGETptr2 lda tempc:ldx tempc+1
3610 sta GETptr:stx GETptr+1
3620 rts
3630 ;
3640 ckrange lda INTVAL+1:cmp strptr+1
3650 beq isequ
3660 bcs ckENDptr
3670 NOTrnge lda #1:rts
3680 inrange lda #0:rts
3690 ;
3700 isequ lda INTVAL:cmp strptr
3710 bcc NOTrnge
3720 ;
3730 ckENDptr lda INTVAL+1:cmp ENDptr+1
3740 bcc inrange
3750 bne NOTrnge
3760 lda INTVAL:cmp ENDptr
3770 bcc inrange
3780 beq inrange
3790 bcs NOTrnge
3800 ;
3810 fxdfl cmp #$80:bcc skp32768
3820 AND #$7f
3830 jsr sfxdfl:lda #<cONsTANt:ldy #>cONsTANt
3840 jsr addem
3850 jmp strit
3860 ;
3870 skp32768 jsr sfxdfl
3880 strit jsr cONvfac1
3890 rts
3900 ;
3910 sGETptr3 lda GETptr:ldx GETptr+1
3920 sta tempi:stx tempi+1
3930 rts
3940 ;
3950 rGETptr3 lda tempi:ldx tempi+1
3960 sta GETptr:stx GETptr+1
3970 rts
3980 ;
3990 bONjour lda #"?":sta delim:ldx #17:stx fileLEN
3992 jsr chrGOt:jsr inpfile
3995 lda #<bONjourm:ldy #>bONjourm:jsr strout
4000 bONGET jsr GET:cmp #"{f8}":beq leSAVE
4010 cmp #"n":bne bONGET:jmp READy
4020 ;
4040 leSAVE ldy #0:lda SAVEtble+1:sta tempj:sty SAVEtble+1
4050 lda SAVEtble+2:sta tempj+1:sty SAVEtble+2
4060 jsr SAVEee2
4070 lda tempj:sta SAVEtble+1
4080 lda tempj+1:sta SAVEtble+2
4090 jmp ds
4100 ;
4110 ;
4120 ;
4130 rentble .byte $8a,$9b,$cb,$a7,$8d,$89
4140 ;RUN,LIST,GO,THEN,GOSUB,GOTO
4150 renmsge1 .ASC " ** illegal line range ** ":.byte 13,0
4160 bONjourm .byte 13:.ASC " ? ".byte 13,o
4200 cONsTANt .byte $90,0,0,0,0
4210 .END 8,"w-64.e5"
stop tok64
(bastext 1.0)
