1210 TOKTBLE .ASC "ADJUST":.BYTE 0
990 .ASC "AUTO":.BYTE 0
1000 .ASC "COLD":.BYTE 0
1010 .ASC "COLOUR":.BYTE 0
1020 .ASC "DEL":.BYTE 0
1030 .ASC "DS":.BYTE 0
1040 .ASC "HELP":.BYTE 0
1050 .ASC "HEX":.BYTE 0
1060 .ASC "HUNT":.BYTE 0
1070 .ASC "LOOK":.BYTE 0
1075 .ASC "MEM":.BYTE 0
1080 .ASC "MERGE":.BYTE 0
1090 .ASC "N":.BYTE 0
1100 .ASC "OFF":.BYTE 0
1110 .ASC "RENUM":.BYTE 0
1120 .ASC "SAVE":.BYTE 0
1130 .ASC "SEND":.BYTE 0
1140 ;.ASC "START".BYTE 0
1150 .ASC "$":.BYTE 0
1160 .ASC "/":.BYTE 0
1170 .ASC "^HI":.BYTE 0
1180 .BYTE 0
1190 ;

1420 ;
1410 COMMANDS .BYTE 13:.ASC " COMMANDS :{SPACE*3}":.BYTE 13
1420 .ASC " {-*10}{SPACE*3}":.BYTE 13,0


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
3490 NAMESTR .ASC "{SPACE*8}":.BYTE 0
3500 ;