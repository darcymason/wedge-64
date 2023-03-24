

# Wedge-64

## Introduction
Wedge-64 is a utility program for the Commodore-64, developed in the early 1980's and published in
the Torpet magazine [Nov/Dec 1983 issue](https://www.tpug.ca/tpug-media/torpet/Torpet_Issue_25_1983_Nov_Dec.pdf) pp. 63-65) and later in [The Best of the Torpet](https://www.tpug.ca/tpug-media/torpet/The_Best_of_TORPET.pdf) (pp. 264-266) and available
on the [Best of the Torpet disk](https://commodore.software/downloads/download/540-associated-book-disks/12531-the-best-of-torpet-disk)

"The Wedge" made it easier to work with disk catalogs and files, and with Basic programs,
offering features like easier file listing and loading, renumbering Basic source code, or searching
Basic listings for specific text.

Wedge-64 is an example of a CHRGET-driven utility: it intercepted the keyboard character stream and checked for a specific starting character (the wedge, ">"); if that character was not found, it passed control back to the previous character handler.

Wedge-64 was written in [PAL assembler](https://csdb.dk/release/?id=18294), in three separate source code files to make loading and editing more manageable.  At the end of the first two files is the filename link to the next one.

## Source Code Recovery
On the 40th anniversary of the original Torpet article, we (original authors Darcy Mason and Alan Wunsche) decided to try to recover the source code from a 5.25" floppy disk that Al still had.

We were able to borrow an XAP1541 cable (with great thanks to [Peter Schepers](https://ist.uwaterloo.ca/~schepers)) to connect a 1541 drive to an old PC with a parallel port.  Then using a [boot CD](https://ist.uwaterloo.ca/~schepers/imaging.html) (thanks again to Peter Schepers) the Star Commander program was used to copy what files we could from the floppy.

We were able to recover the 'version 6' source code (`.e6` files).  The original files were named "w-64.e6", "w-64+.e6" and "w-64£.e6"; names have been altered in the Windows-based versions of the files stored here.  We also had a physical printout of the PAL output for the version as published in the article (version `.e8`).  The differences were mostly in line numbering and positioning of data blocks.  The version `e6` source code was edited to correspond to the PAL output.

## Installating and running

Compiled (assembled) versions of the Wedge were targeted at specific memory blocks: e.g. hex $CO00, or $A000.

After loading the program, the wedge could be activated by a SYS command, e.g.

```
LOAD"WEDGE-64.$C000",8
SYS 12*4096
```

The '12`*`4096' above represents the hex $C000 address.

The Wedge could be turned off by executing code 3 bytes further, e.g.:
```
SYS 12*4096+3
```
for the Wedge loaded at address $C000.


