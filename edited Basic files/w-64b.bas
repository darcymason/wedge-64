
1190 ;

1420 ;


1930 FILENAME *= *+50
1940 ;


2020 STMSGE .ASC "{DOWN}MERGING LINE: "
2060 .BYTE 0
2070 CRIGHT .ASC "{RIGHT*14}"
2080 .BYTE 0



2720 OURMSGE .ASC " ** INVALID WEDGE COMMAND ** ":.BYTE 13,0
2720 HELLO .BYTE 13:.ASC " WEDGE-64 (C)1983 D.MASON & A.WUNSCHE ":.BYTE 13
2730 .ASC " MERGE ADAPTED FROM BASIC AID ":.BYTE 13
2740 .ASC " PERMISSION TO USE BUT NOT TO SELL ":.BYTE 13,0
2750 OFFF .BYTE 13:.ASC " WEDGE-64 DISABLED ":.BYTE 13,0


LDA #",":JSR PRINT:LDA #"8":JSR PRINT:LDA #":":
3470 JSR PRINT:JSR CGRET:LDA #"{UP}":JSR PRINT
3480 LDX #$FF:TXS:JMP RREADY+12

3500 ;
';;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

3200 REVERSE .ASC "{REVERSE ON}{SPACE*20}{REVERSE OFF}"
3210 .BYTE 13,0
3220 COLTBLE .ASC "{BLACK}{WHITE}{RED}{CYAN}{156}{GREEN}{BLUE}{YELLOW}{ORANGE}{BROWN}{PINK}{DARK GRAY}{GRAY}{LIGHT GREEN}{LIGHT BLUE}{LIGHT GRAY}"
3230 ;

--------------------------------------


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


3990 BONJOURM .BYTE 13:.ASC " ? ".BYTE 13,O