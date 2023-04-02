python hatoucan.py w-64a.bas w-64a.e8
python hatoucan.py w-64b.bas w-64b.e8
python hatoucan.py w-64c.bas w-64c.e8
c1541.exe -format "wedge64","01" d64 w64.d64 -attach w64.d64 -write w-64a.e8 w-64a.e8 -write w-64b.e8 w-64b.e8 -write w-64c.e8 w-64c.e8
