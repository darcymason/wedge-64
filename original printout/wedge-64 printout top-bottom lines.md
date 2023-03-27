Scan of the Wedge-64 printout missed lines near top and bottom. Here are what they were.

| Page | Lines                        |
|-----:|------------------------------|
| 1    | N/A                          |
|      |  630: STARRAY = $2F          |
| 2    |  640: LOADFAC2 = $BBA2       |
|      | 1070: INY                    |
| 3    | 1070: bne TOkloop            |
|      | 1520: CMP #0                 |
| 4    | 1520: bne CONT2              |
|      | 1850: LDA #0                 |
| 5    | 1850: sta fiLEName,x         |
|      | 2150: JSR CLALL              |
| 6    | 2150: JMP READY              |
|      | 2440: COMP $"^"              |
| 7    | 2440: BEQ END2               |
|      | 2700: JMP READY --visible    |
| 8    | 2730: LDA #1 XXX #8?         |
|      | 3010: BNE ABCDEF             |
| 9    | 3010: TXA                    |
|      | 3240: LDX ST                 |
| 10   | 3240: BNE CATDONE            |
|      | 3480: JSR INPBYTE            |
| 11   | 3490: TAX                    |
|      |                              |
|      | 250:  BCS FINI               |
| 12   | 270: DUMPOK  LDY #0          |
|      | 590:  JSR PRINT              |
| 13   | 600: LDA TEMPA               |
|      | 930: INY                     |
| 14   | 930: LDA (VARPTR),Y          |
|      | 1530: LAB2  INY              |
| 15   | 1540: BEQ LAB1               |
|      | 2090: BEQ GOBACK4            |
| 16   | 2100: JSR CHRGOT             |
|      | 2410: STY ENDPTR+1           |
| 17   | 2420: INY                    |
|      | 2860: LDX VARPTR+1           |
| 18   | 2870: STA GETPTR             |
|      | 3200: CLC                    |
| 19   | 3200: ADC GETPTR             |
|      | 420: STX RENENDLN+1          |
| 20   | 430: STA INTVAL              |
|      | 720: BNE TABLELOP            |
| 21   | 730: BEQ ALOOP               |
|      | 1070: CMP TEMPC              |
| 22   | 1080: BCS DONETHIS           |
|      | 1310: JMP RENRING2  (?)      |
| 23   | N/A                          |
|      | 1730: BNE PASS2DN            |
| 24   | 1750: NOPROB  LDY #2         |
|      | 2090: JMP READY              |
| 25   | N/A                          |
|      | 2490: STA $22                |
| 26   | 2500: LDA $60                |
|      | 2890: JSR NEW                |
| 26   | 2500: LDA $60                |
|      | 2890: JSR NEW                |
| 27   | 2500: LDA $60                |
|      | 2890: JSR NEW; UNDER [ NEW ] |
| 28   | 2900: JSR RECHAIN            |
|      | 3290: RTS                    |
| 29   | 3310: LDA TEMPA              |
|      | 3760: RTS                    |
| 30   | 3780: BONJOUR  LDA #"_"      |
|      | 4120: BYTE0                  |
| 31   | 4130: ASC "MEM"              |
|      | 4550: TEMPB *= *+1           |
| 32   | 4560: INCR *=*+1             |
|      | N/A                          |



