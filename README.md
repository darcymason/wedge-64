

# Wedge-64

## Introduction
Wedge-64 is a utility program for the Commodore-64, developed in the early 1980's and published in
the Torpet magazine [Nov/Dec 1983 issue](https://www.tpug.ca/tpug-media/torpet/Torpet_Issue_25_1983_Nov_Dec.pdf) (pp. 63-65) and later in [The Best of the Torpet](https://www.tpug.ca/tpug-media/torpet/The_Best_of_TORPET.pdf) (pp. 264-266) and available
on the [Best of the Torpet disk](https://commodore.software/downloads/download/540-associated-book-disks/12531-the-best-of-torpet-disk)

"The Wedge" made it easier to work with disk catalogs and files, and with Basic programs,
offering features like easier file listing and loading, renumbering Basic source code, and searching Basic listings for specific text.

Wedge-64 is an example of a CHRGET-driven utility: it intercepted the keyboard character stream and checked for a specific starting character (the 'wedge', ">"); if that character was not found, it passed control back to the previous character handler.

Wedge-64 was written in [PAL assembler](https://csdb.dk/release/?id=18294), in three separate source code files to make loading and editing more manageable.  At the end of the first two files is the filename link to the next one.

## Source Code Recovery
On the 40th anniversary of the original Torpet article, we (original authors [Darcy](https://github.com/darcymason/) [Mason](https://www.linkedin.com/in/darcy-mason-b6753357/) and [Alan](https://github.com/alanwunsche/bio) [Wunsche](https://www.linkedin.com/in/alanwunsche/)) decided to try to recover the source code from a 5.25" floppy disk that Alan still had.

We borrowed an XAP1541 cable (with great thanks to [Peter Schepers](https://ist.uwaterloo.ca/~schepers)) to connect a 1541 drive to an old PC with a parallel port.  Then using a [boot CD](https://ist.uwaterloo.ca/~schepers/imaging.html) (thanks again to Peter Schepers) the Star Commander program was used to copy what files we could from the floppy.

We were able to recover the 'version 6' source code (`.e6` files).  The original files in order were named "w-64.e6", "w-64+.e6" and "w-64£.e6" ('£' on DOS/Windows appears as '`\`' on C-64).  They were copied to the RAM disk created by the boot CD, then from there to 3.5" floppy drive.  The old PC was rebooted in Window (ME) to copy the 3.5" floppy files to a USB thumb drive which could be read on a modern laptop.

The files were converted from binary C-64 Basic files to ascii text using [bastext](https://github.com/nafmo/bastext) for editing on Windows. However, there were problems converting in the other direction, which led to the use of a modified Python script as detailed below.

 We had a physical printout of the PAL output (different format than source code) for the version as published in the article (version `.e8`).  The differences were mostly in line numbering and positioning of data blocks.  The version `e6` source code was edited to recreate the `.e8` source code.  Eventually the files were renamed because of problems converting back and forth to d64 disk images: the three source files became (on Windows) "w-64a.bas", "w-64b.bas" and "w-64c.bas". These were then run through a modified ascii to BASIC Python script (`hatoucan.py`, included in this repo) to convert to files "w-64a.e8", "w-64b.e8", and "w-64c.e8", which were then transferred to d64 disk image using the `c1541` utility included with WinVICE, for mounting in the WinVICE emulator.

The source was assembled and compared in binary with the original binary on the "Best of the Torpet" d64 disk.  After several edits (mostly for ascii vs. petscii differences), they matched except for some extra bytes at the end of the original, which included a filename "WEDGE-64-$C000.00" and some seemingly random bytes after that.


## Installating and running

Wedge-64 can still be run on an original Commodore-64 or in emulators such as [VICE](https://vice-emu.sourceforge.io/).

Compiled (assembled) versions of the Wedge are targeted at specific memory blocks: e.g. hex $CO00, or $A000.  These are available on the Best of the Torpet disk linked above.

After loading the program, the wedge can be activated by a SYS command, e.g.

```
LOAD"WEDGE-64-$C000.C",8,1
SYS 12*4096
```

The '12`*`4096' above represents the hex $C000 address.  Note the extra ",1" on the end is needed to load the wedge into the correct memory address.

The Wedge can be turned off using:
```
>off
```
or by executing code 3 bytes further than the start address, e.g.:
```
SYS 12*4096+3
```
for the Wedge loaded at address $C000.


