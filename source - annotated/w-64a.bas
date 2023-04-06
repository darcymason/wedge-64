10 OPEN 4,8,1,"wedge-64-$c000"
100 REM WEDGE-64
110 REM BY DARCY MASON & ALAN WUNSCHE
120 :
130 SYS 700:*= $C000:BLOCKK = *:.OPT O4
150 JMP BEGIN:JMP OFF
160 ;
170 GETPTR = $7A
180 SYNERROR = $AF08
190 CHRGET = $0073
200 SHIFTKEY = $028D
210 CRUNCH = $A579
220 CHRGOT = $0079
230 PRINT = $FFD2
240 PRINT2 = $E716
250 RREADY = $A474
260 STROUT = $AB1E
270 STOPKEY = $FFE1
280 INPUT = $FFCF
290 TALK = $FFB4
300 SERIN = $FFCF
310 UNLSN = $FFAE
320 UNTALK = $FFAB
330 SYSLOAD = $E175
340 GET = $FFE4
350 NUMCHAR = $B7
360 SETLFS = $FFBA
370 SETNAM = $FFBD
380 OPEN = $FFC0
390 CHKIN = $FFC6
400 ST = $90
410 PRINTLN = $BDCD
420 CLOSE = $FFC3
430 INTVAL = $14; where LINGET result is stored
440 BUFF = $0200
450 MOVEMEM = $A3B8
460 CLALL = $FFE7
470 RECHAIN = $A533
480 BACKTEXT = $A68E
490 COMMA = $AEFD
500 EVALEXP = $AD9E
510 FLFXD = $B7F7
520 CALLADD = $A48C
530 DEVNP = 128
540 ERROREX = $A437
550 TOM = $37
560 RENTEMP = $8D
570 RENINC = $28
580 MULTFLAG = $2A
590 RENCOUNT = $8B
600 QUMODE = $08
610 STRFAC = $BCF3
620 VARSTART = $2D:SAVEPROG = $E15F
630 STARRAY = $2F
640 LOADFAC1 = $BBA2
650 CONVFAC1 = $BDDD
660 VARPTR = $5F
670 STRPTR = $FD
680 ENDPTR = $26
690 INPFXD = $A96B; LINGET - read num and convert to two-byte int
700 FINDLN = $A613
710 ILLQTY = $B248
720 RECHNPTR = $22
730 MOVETO = $FD
740 MOVEFROM = $26
750 SFXDFL = $B391
760 KEYB = 631
770 KEYBLEN = 198
780 FOUNDNUM = $A49F:STARTB = $2B
790 ADDEM = $B867
800 CNTPTR = $19
810 MEMFAC2 = $BA8C
820 ;
830 ;
840 BEGIN JSR INIT
850 READY JMP RREADY
860 ;
870 ;
880 ; ---- ENTRY FROM CHRGET ------
890 ;
900 GETCH2 INC GETPTR:BNE NOT0:INC GETPTR+1
910 NOT0 JSR CHRGOT:STX TEMPX:STY TEMPY
920 TSX
921 ; XX below only allowed from A407
922 LDA $0101,X
924 CMP #<CALLADD
926 BNE OLDGET
930 LDA $0102,X
932 CMP #>CALLADD
934 BEQ GOODCALL
936 ;
940 OLDGET LDX TEMPX:LDY TEMPY:JMP CHRGOT
945 ;
950 CKAUTO JSR AUTOLN:JMP CHRGOT
960 GOODCALL JSR CHRGOT:BCC CKAUTO
970 ;
980 ;
990 CMP #">":BNE OLDGET
1000 JSR CHRGET:PLA:PLA
1010 ;
1020 ; CHECK FOR VALID COMMANDS
1030 ;
1040 LDX #0:STX TOKNUM
1050 USERTOK LDY #0
1060 TOKLOOP LDA TOKTBLE,X:BEQ GOODTOK:CMP (GETPTR),Y
1070 BNE NEXTTOK:INX:INY:BNE TOKLOOP
1080 ;
1090 NEXTTOK INX:LDA TOKTBLE,X:BNE NEXTTOK:INX:INC TOKNUM
1100 LDA TOKTBLE,X
1102 BEQ SERROR2;  XXX - del?
1004 BNE USERTOK;    let run through
1110 ;
1120 SERROR2 JMP OURERR
1130 ;
1140 ;
1150 GOODTOK JSR UPDATE
1160 LDA TOKNUM:ASL:TAX:LDA TOKADD,X:STA TOKVCTR:LDA TOKADD+1,X
1170 STA TOKVCTR+1
1180 JSR CHRGOT:JMP (TOKVCTR)
1190 ;
1200 ;
1210 TOKADD .WORD ADJUST
1220 .WORD AUTO
1230 .WORD COLD
1240 .WORD COL
1250 .WORD DEL
1260 .WORD DS
1270 .WORD HELP
1280 .WORD HEX
1290 .WORD HUNT
1300 .WORD DUMP
1310 .WORD MEMORY
1320 .WORD MERGE
1330 .WORD NAME
1340 .WORD OFF
1350 .WORD RENUM
1360 .WORD SAVEM
1370 .WORD SEND
1380 .WORD START
1390 .WORD DISK
1400 .WORD LOAD
1410 .WORD BONJOUR; XXX del
1420 ;
1430 ;
1436 ; ==== >MERGE "filename" =============================
1438 ; Merge specified filename from disk with the one in memory
1440 MERGE LDX #17
1442 STX FILELEN
1444 JSR INPFILE
1450 ;
1460 JSR STRTMSGE
1470 LDA #2
1472 LDX #8 ; XX DISKDV
1474 LDY #0
1476 JSR OPENFILE
1478 ;
1480 CONT1 LDX #2:JSR CHKIN
1490 LDX #0
1500 JSR GETCHR:JSR GETCHR ;LOAD ADDRESS
1510 LNLOOP JSR GETCHR:JSR GETCHR ;LINK
1520 CMP #0:BNE CONT2
1530 JMP PGMOVER
1540 CONT2 JSR GETLN
1550 ;
1560 ;PUT THE LINE IN
1570 JSR PUTIN
1580 JMP LNLOOP
1590 ; ====================================================
1600 PGMOVER JSR CGRET
1610 JMP DS
1620 ;
1630 ; GET A BASIC LINE
1640 ;
1650 GETLN LDX #255:JSR GETCHR
1660 STA INTVAL:JSR GETCHR:STA INTVAL+1
1670 STX TEMPX:LDA INTVAL+1:LDX INTVAL:JSR PRINTLN:JSR CGRET
1680 LDA #"{UP}":JSR PRINT:LDA #<CRIGHT:LDY #>CRIGHT:JSR STROUT
1690 LDX TEMPX
1700 LL5 INX:CPX #$4E:BCS LL4
1710 JSR GETCHR:STA BUFF,X:CMP #0:BNE LL5
1720 LL4 INX:INX
1730 STA BUFF,X
1740 INX:INX:INX
1750 STX $0B      ; BUFF PTR
1760 RTS
1770 ;
1780 SERROR LDA #34:STA DELIM:JMP SYNERROR
1790 INPFILE LDX #0:LDY #0
1800 CMP DELIM:BNE SERROR
1810 FILELOOP CPX FILELEN:BEQ STRERR:JSR CHRGET2:BEQ NAMEDONE
1820 CMP DELIM:BEQ NAMEDON
1830 STA FILENAME,X:INX:BNE FILELOOP
1840 NAMEDON INY
1850 NAMEDONE CPX #0:BEQ SERROR:STX NUMCHAR:LDA #0:STA FILENAME,X
1860 JSR UPDATE
1870 LDX #<FILENAME:LDY #>FILENAME
1880 LDA NUMCHAR:JSR SETNAM
1890 LDA #34:STA DELIM:JMP CHRGOT
1900 ; STRING TOO LONG MESSAGE
1910 STRERR LDA #34:STA DELIM:LDX #23:JMP ERROREX
1920 ;
1930 ; ERROR ROUTINES
1940 ;
1950 STERROR CPY #64:BNE CONTT:JMP PGMOVER
1960 CONTT JMP DS
1970 ;
1980 GETCHR JSR INPUT:LDY ST:BNE STERROR
1990 RTS
2000 STRTMSGE LDA #<STMSGE:LDY #>STMSGE
2010 JMP STROUT
2020 CHRGET2 INY:LDA (GETPTR),Y:RTS  ; XX Not worth it, do whenever needed
2030 ;
2040 ;
2046 ; ==== >/ "filename"    command ======================
2048 ; load file without relocating. Same as LOAD "filename",8,1
2050 LOAD LDX #17:STX FILELEN:JSR INPFILE
2060 LDA #1
2062 LDX #8 ; XX DISKDV
2064 LDY #1
2070 JSR SETLFS
2080 LDA #0:STA $0A:JMP SYSLOAD
2090 ; ====================================================
2092 ;
2094 ;
2096 ; ==== >DS command ====================================
2098 ; display the disk status
2100 DS LDA #1:JSR CLOSE:LDA #2:JSR CLOSE:JSR CLALL
2110 LDA #32:JSR PRINT
2120 LDA #0
2122 JSR SETNAM
2124 JSR OPENCC ; XXX opencc jumps to DS
2130 LDX #1:JSR CHKIN
2140 DSLOOP JSR INPUT:JSR PRINT:CMP #13:BNE DSLOOP:LDA #" ":JSR PRINT2
2150 LDA #1
2152 JSR CLOSE
2154 JSR CLALL
2156 JMP READY
2160 ; ====================================================
2162 ;
2164 ;
2166 ; ==== >OFF    command ===============================
2168 ; Disable the Wedge
2170 OFF LDA #<OFFF:LDY #>OFFF:JSR STROUT:JSR RESGETT:JMP READY
2180 ; ====================================================
2190 RESGETT LDX #2:RESGET LDA SAVETBLE,X:STA CHRGET,X
2200 LDA #0:STA SAVETBLE,X:DEX
2210 BPL RESGET:RTS
2220 ;
2228 ; ==== >START "filename"    command ==================
2229 ; Display load address of program on disk (hex and decimal)
2230 START LDX #17:STX FILELEN:JSR INPFILE
2240 LDA #2
2242 LDX #8; XX DISKDV
2244 LDY #$0
2246 JSR OPENFILE
2248 ;
2250 LDX #2:JSR CHKIN
2260 JSR INPUT; LOAD ADDRESS LO-BYTE
2270 JSR TIMER
2280 TAX:STX TEMPX:JSR INPUT; HI-BYTE
2290 JSR TIMER
2300 STA TEMPY:LDA #2:JSR CLOSE:JSR CLALL
2310 LDA #"$":JSR PRINT
2320 LDA TEMPY:LDX TEMPX:JSR PRINTADD
2330 JSR SPACE:JSR PRINT
2340 LDA TEMPY:LDX TEMPX:JSR PRINTLN
2350 JSR SPACE
2360 JSR CGRET
2362 JMP DS
2368 ; ====================================================
2370 TIMER LDY #100:TIMELOOP DEY:BNE TIMELOOP:RTS;  XXX ?
2380 ;
2386 ; ==== >SEND "disk command" ==========================
2388 ; Send disk command in BASIC 2.0 form to the command channel
2390 SEND LDX #80;  XXX filename only 55 saved
2392 STX FILELEN
2394 JSR INPFILE
2400 JSR OPENCC; command channel 15
2402 JMP DS
2410 ; ====================================================
2413 ;
2415 ;
2416 ; ==== >HELP command =================================
2418 ; list the Wedge commands
2420 HELP LDA #<COMMANDS:LDY #>COMMANDS:JSR STROUT
2430 LDY #0
2440 LABEL LDA TOKTBLE,Y:CMP #"{up arrow}":BEQ END2:JSR SPACE:LDA #">"
2450 JSR PRINT:HELPLOOP LDA TOKTBLE,Y
2460 BEQ END1
2470 NOTUPARR JSR PRINT:INY:BNE HELPLOOP
2480 END1 JSR CGRET
2490 END3 INY:LDA TOKTBLE,Y
2500 BNE LABEL
2510 JMP READY
2512 ; ====================================================
2520 END2 INY:LDA TOKTBLE,Y:BNE END2:JMP END3; XX Delete along with HI
2530 ;
2540 ; INITIALIZE
2550 ;
2560 INIT LDA BLOCK
2562 CMP #$A0
2564 BCS OVERIT
2570 CMP TOM+1
2572 BCS OVERIT
2573 STA TOM+1
2574 LDA #255
2576 STA TOM
2578 JSR NEW
2580 ;
2590 OVERIT LDA #0
2592 STA INCR
2594 LDA #34
2596 STA DELIM
2598 ;
2600 LDX #2
2601 ; init colours
2602 LDA #2
2603 STA 53280
2604 LDA #15
2606 STA 53281
2607 LDA #0
2608 STA 646
2609 ;
2610 LDA SAVETBLE,X
2615 BNE HELLOO
2616 ;
2617 ; XX saveget - do both at once?
2618 ; change to error vector or tokens?
2619 ; if error - also do crunch for basic lines
2620 SAVEGET LDA CHRGET,X:STA SAVETBLE,X:DEX:BPL SAVEGET
2630 LDX #2:INITGET LDA GETTBLE,X:STA CHRGET,X:DEX:BPL INITGET
2639 ; XX shorten message
2640 HELLOO LDA #<HELLO:LDY #>HELLO:JMP STROUT
2650 ;
2660 SAVETBLE .BYTE 0,0,0,0
2670 GETTBLE .BYTE $4C
2680 .WORD GETCH2
2688 ;
2689 ; XX use syntax error instead
2690 OURERR LDA #<OURMSGE:LDY #>OURMSGE
2700 JSR STROUT:JMP READY
2710 ;
2720 OPENCC LDA #1
2730 LDX #8; XX DISKDV
2732 LDY #15
2734 OPENFILE JSR SETLFS
2740 JSR OPEN; COMMAND CHANNEL OPEN !
2750 LDY ST
2760 BEQ OPENED
2770 CMP #DEVNP; XXX CPY!
2772 BNE JUMPDS
2773 LDX #5
2774 JMP ERROREX
2776 JUMPDS JMP DS
2777 ;
2780 OPENED RTS
2790 ;
2800 ;
2809 ; XX  print nib/byt/add  wrong order
2810 PRINTNIB CLC:ADC #$F6:BCC ADD2
2820 ADC #$06:ADD2 ADC #$3A:JMP PRINT
2830 ;
2840 PRINTBYT PHA:LSR:LSR:LSR:LSR:JSR PRINTNIB
2850 PLA:AND #$0F:JMP PRINTNIB
2860 ;
2870 PRINTADD JSR PRINTBYT:TXA:JMP PRINTBYT
2880 ;
2890 OUROPEN JSR OPEN
2892 LDY ST
2894 BEQ OKST
2895 ; XX check device not present!
2896 JMP DS
2897 ;
2900 OKST RTS
2910 ;
2920 ;
2926 ; ==== >HEX ($) number   command =====================
2928 ; if $ present, displays decimal value of hex number
2929 ; else displays hex value of decimal number
2930 HEX JSR CRUNCH:JSR CHRGET:CMP #"$":BEQ HEX2:JSR EVALEXP:JSR FLFXD
2940 JSR SPACE:LDA #"$":JSR PRINT:
2950 LDX INTVAL:LDA INTVAL+1
2960 JSR PRINTADD
2970 HEXEND JSR SPACE:JSR CGRET:JMP READY
2980 ;
2990 ABCDEF JMP SYNERROR
3000 HEX2 JSR INPADD
3010 STA TEMPX:JSR SPACE:JSR CHRGET2:BNE ABCDEF:TXA:LDX TEMPX:JSR PRINTLN
3020 JMP HEXEND
3025 ; ====================================================
3030 ;
3036 ; ==== >$(drive or pattern)   command ================
3037 ; Display a directory of files on disk
3038 ; e.g. >$0,   >$st*,  >$:*=seq
3040 DISK STA FILENAME+1
3050 LDY #255:LDA #"$":STA FILENAME
3060 CATLOOP2 JSR CHRGET2:STA FILENAME+1,Y
3070 BEQ CNAMEOK2:CPY #49:BCC CATLOOP2:JMP STRERR
3080 CNAMEOK2 INY
3081 STY NUMCHAR
3082 INY
3083 LDA #0
3084 STA FILENAME+2,Y
3086 LDA #1
3087 LDX #8; XX DISKDV
3090 LDY #$60
3100 JSR SETLFS:JSR CGRET
3110 JSR UNLSN:JSR UNTALK:LDA NUMCHAR:LDX #<FILENAME:LDY #>FILENAME
3120 JSR SETNAM
3122 JSR OPEN
3123 ; XX Dev. W.P.?
3124 LDX #1
3126 JSR CHKIN
3130 JSR SERIN:JSR SERIN;  IGNORE LOAD ADDRESS
3140 GETLINK2 JSR SERIN:JSR SERIN:LDX ST:BNE CATDONE ; IGNORE LINK
3150 LDA #32:JSR PRINT2
3160 JSR SERIN:TAX:JSR SERIN:JSR PRINTLN   ; PRINT PGM  # BLOCKS
3170 LDA #" "
3171 ; XX four calls in a row?
3172 JSR PRINT2:JSR PRINT2:JSR PRINT2:JSR PRINT2
3180 DIRLOOP2 JSR SERIN:JSR PRINT2:BNE DIRLOOP2
3190 LDA #13:JSR PRINT2:JMP GETLINK3
3200 ;
3210 CATDONE JSR UNTALK:JSR CGRET:JSR PRINT
3220 JMP DS
3230 ; ====================================================
3240 GETLINK3 JSR SERIN:JSR SERIN:LDX ST:BNE CATDONE ; IGNORE LINK
3250 LDA #32:JSR PRINT2
3260 JSR SERIN:TAX:JSR SERIN:JSR PRINTLN   ; PRINT PGM  # BLOCKS
3270 LDA #32:JSR PRINT2
3280 DIRLOOP3 JSR SERIN:JSR PRINT2:BEQ CATDONE:CMP #34:BNE DIRLOOP3
3290 LDY #18
3300 CALNLOOP JSR SERIN:CMP #0:BEQ CATDONE:JSR PRINT2:DEY:BNE CALNLOOP
3310 LDA #" ":JSR PRINT2:JSR PRINT2
3320 LDA #":":JSR PRINT
3330 CALNLP2 JSR SERIN:JSR PRINT2:BNE CALNLP2
3340 JSR STOPSHFT:BEQ CATDONE
3350 LDA #13:JSR PRINT2:JMP GETLINK3
3360 ;
3366 ; ==== >N ("filename")    command ====================
3368 ; if no filename, display last Wedge filename or HUNT string
3369 ; else set the filename
3370 NAME CMP #34:BEQ USERNAME
3380 LDA #<NAMESTR:LDY #>NAMESTR:JSR STROUT
3390 ;
3400 LDA #34:JSR PRINT
3410 LDA #<FILENAME:LDY #>FILENAME:JSR STROUT
3420 LDA #34:JSR PRINT
3430 LDA #<USERSTRG:LDY #>USERSTRG:JSR STROUT:JSR CGRET
3440 LDA #"{crsr up}":JSR PRINT
3450 LDX #$FF:TXS:JMP RREADY+12
3460 ;
3470 USERNAME LDX #70:STX FILELEN:JSR INPFILE:JMP READY
3472 ; ====================================================
3480 INPADD LDA #0:STA TEMPY:TAY:JSR INPBYTE
3490 TAX:STX TEMP8:LDA #0:STA TEMPY
3500 INPBYTE JSR INPNIB
3510 ASL:ASL:ASL:ASL
3520 STA TEMPY
3530 INPNIB JSR CHRGET2
3540 CMP #"0":BCC SERROR3
3550 CMP #":":BCC O9
3560 CMP #"A":BCC SERROR3
3570 CMP #"G":BCS SERROR3
3580 SBC #$06
3590 O9 AND #$0F
3600 ORA TEMPY
3610 LDX TEMP8
3620 RTS
3630 SERROR3 JMP SYNERROR
3636 ; ==== >COLD command =================================
3638 ; resets computer
3640 COLD LDA #0
3642 LDX #2
3644 COLDLOOP STA SAVETBLE,X
3646 DEX
3647 BPL COLDLOOP
3648 JMP 64738; cold reset
3649 ; ====================================================
3650 SPACE LDA #" "
3652 JMP PRINT; XX do with BIT disguised! Also Quote
3654 ; -------------------
3660 CGRET LDA #13:JMP PRINT
50000 .FILE 8,"w-64b.e8"