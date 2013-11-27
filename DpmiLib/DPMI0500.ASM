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
Include ..\include\DpmiLib.Inc             
  Segment32                
                          
Public _DpmiMemInfo       
                          
_DpmiMemInfo DpmiMemInfoStruc <>  ;Struc de Info de Mem¢ria
                          
;---------------------------------------------------------------------                                   
; Obt‚m a info de memoria e preenche a struc _DpmiMemInfo
;                                 
;---------------------------------------------------------------------
Public _DpmiGetMemoryInfo 
                                                         
_DpmiGetMemoryInfo Proc Near
                                 
             If PreserveRegsOnCall
                push eax edi es
             EndIf               
                Mov es,cs:_SelData32
                mov edi,offset _DpmiMemInfo
                Mov eax,0500h  
                int 31h         
                               
             If PreserveRegsOnCall
                pop es edi eax
             EndIf               
                ret            
             EndP                 
                                   
EndSegment32                      
End                               
