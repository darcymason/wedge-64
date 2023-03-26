Text extracted from "The Best of the TORPET Plus More for the Commodore 64 and the VIC·20": https://www.tpug.ca/tpug-media/torpet/The_Best_of_TORPET.pdf - 1984. p.264-266.

---

# WEDGE-64
By Darcy Mason & Alan Wunsche, Oshawa, Ont.

## HISTORY OF WEDGE-64

The Wedge-64 was developed in the summer of 1983 during the Summer Canada '83 project spon- sored by the Durham Board of Education. The "Wedge" actually started out as a machine language merge utility for Commodore 64 users. After the merge was completed, we realized that the C-64 was lacking in good catalog routines. At about the time that the catalog and disk status routine was done, we decided to add a few more commands. Hex, look, and hunt followed and we soon began thinking that our program could evolve into an aid that would help the C-64 pro- grammer create BASIC programs more easily and efficiently. Below is the result of our efforts. As with most programs, there may be some bugs that weren't spotted in the debugging process. We would be interested in hearing about any questions, problems, or comments about the Wedge, as we would like to make this program as good as possible.

## SUMMARY OF COMMANDS
Wedge = ▶

▶adjust - displays all colours for adjustment of monitor.

▶auto - prints out next line number in given increment.

▶cold - resets computer.

▶colour - sets border, screen, and cursor col- ours.

▶del - deletes a given range of lines.

▶ds - displays disk status.

▶help - lists all commands of the Wedge summarized here.

▶hex - gives decimal of hex number or vice versa.

▶hunt - searches through program for given string.

▶look - displays values in variables currently in use.

▶mem - memory dump in hex with ASCII on right hand side.

▶merge - merges program from disk with one in memory.

▶n - displays last filename used in Wedge.

▶off - disables Wedge.

▶renum - renumbers program or line range. 

▶save - saves program to disk.

▶send - sends command string to disk via command channel

▶start - displays load address of file on disk in hex and decimal..

▶$ - displays directory of programs on disk.

▶/ - loads program from disk.

---

## ADDITIONAL INFORMATION

- None of the **Wedge** commands have abbreviations as BASIC commands do, i.e., the whole word must be entered.

- Any disk commands will cause the computer to "hang up" if the disk drive is not connected. If any problem with disk access occurs, then press RUN/STOP and RESTORE simultaneously to regain control.

- All disk commands operate on disk device 8.

- The commands ▶hunt, ▶Iook and ▶mem may be frozen by pressing the shift or shift lock keys. Release the shift key to continue.

- The **Wedge** is CHRGET-driven and may therefore co-exist with an interrupt-driven machine language routine at another location.