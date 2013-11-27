
DpmiRegisters Struc
        _Di dw ?,?
        _Si DW ?,?
        _bp dw ?,?
            dd 0
        _bx dw ?,?
        _dx dw ?,?
        _cx dw ?,?    
        _ax dw ?,?
        _Flags dw ?    
        _ES dw ?
        _ds dw ?
        _Fs dw ?    
        _gs dw ?
        _ip dw ?
        _cs dw ?
        _sp dw ?
        _ss dw ?
DpmiRegisters ends  

DpmiMemInfoStruc Struc
   _LargestAvailBlock          dd ? ;em bytes
   _MaxUnlockedPgAllocation    dd ?            
   _MaxLockedPgAllocation      dd ?            
   _TotalLinAddressSpace       dd ? ;em p ginas
   _TotalUnlockedPages         dd ?
   _FreePages                  dd ?
   _TotalPhysicalPages         dd ?
   _FreeLinAddxSpace           dd ? ;em p ginas
   _SizeOfPagingFile           dd ? ;em p ginas
   _Pad                        dd ?,?,?
DpmiMemInfoStruc Ends                       
