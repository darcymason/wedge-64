
1190 ;

1420 ;



1940 ;








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


--------------------------------------



150 rentemp = $8d:reninc = $28
160 multflag = $2a:rencount = $8b
170 ;

210 qumode = $08

250 cntptr = $19
260 memfac2 = $ba8c
270 addem = $b867; add fac2 TO fac1
280 strfac = $bcf3
290 ;
300 ;


3990 BONJOURM .BYTE 13:.ASC " ? ".BYTE 13,O