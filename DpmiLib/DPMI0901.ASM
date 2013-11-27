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
; Desactiva o virtual Int state                                          
;---------------------------------------------------------------------
Public _DpmiVSti
                                                         
_DpmiVSti Proc Near

       If PreserveRegsOnCall
          push eax
       EndIf
          mov eax,900h
          int 31h
       If PreserveRegsOnCall
          pop eax
       EndIf
          ret
       EndP
                                   
EndSegment32                      
End                               
