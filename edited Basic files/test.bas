10 sys 700
20 *=$c000
22 chrout = $ffd2 ;kernal routine
30 .opt oo
40 lda #1 ;can use decimal or hex values wherever convenient
50 sta 53280
60 lda #$0e ;light blue:sta $d021 ;set background color
80 ldy #textend-mytext
90 loop lda mytext,y
100 jsr chrout
110 dey:bpl loop ;print the thing (can put many instructions on one line)
120 rts
200 .byte 0,1,$44,20,"a",64 ;stuff for no reason
210 mytext .asc "strings aren't difficult to add into PAL"
220 textend .byte 0
1000 ; from www.lemon64.com/forum/viewtopic.php?t=79057
