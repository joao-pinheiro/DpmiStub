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
; Obt‚m os dados do Dpmi Server
; ver o return da fn 400h
;                           
;---------------------------------------------------------------------
Public _DpmiGetVersion                                
                                                         
_DpmiGetVersion Proc Near
                                             
                Mov eax,0400h   
                int 31h         
                ret
                                  
             EndP                 
                                   
EndSegment32                      
End                               
