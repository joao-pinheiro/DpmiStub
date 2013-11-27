;####################################################################
;
; Dpmi Stub Loader v1.0b
; 
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
; 
; Biblioteca de Fun‡äes DPMI
;
;
;####################################################################
  
.model large,pascal           
.386p
Locals
  
Include ..\include\Segs.Inc
Include ..\include\Stub.inc
Include ..\include\Defs.Inc

  Segment32                
                          
;---------------------------------------------------------------------                                   
; Locka a zona linear especificada 
; o lock ‚ page Granular
; Retorna Eax -> Status Flag
;                                 
;---------------------------------------------------------------------
Public _DpmiLockZone 
                                                         
_DpmiLockZone Proc Near
             Arg @StartLinAddx:dword,@sizeinbytes:dword
 
             If PreserveRegsOnCall
                push ebx ecx esi edi
             EndIf                  
                                    
                mov eax,600h        
                mov ebx,@startLinAddx
                mov esi,@sizeInBytes
                mov cx,bx           
                mov di,si           
                shr ebx,16          
                shr esi,16          
                int 31h             
                mov eax,0           
                setnc al            
                                    
             If PreserveRegsOnCall  
                pop edi esi ecx ebx
             EndIf                  
                ret            
             EndP                 
                                   
EndSegment32                      
End                               
