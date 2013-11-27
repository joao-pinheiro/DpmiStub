;####################################################################
;
; Dpmi Stub Loader v1.0b
; 
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
; 
; Biblioteca de Fun‡äes DPMI - Vari veis
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

Include ..\include\Structs.Inc

;-------------------------------------------------------------------
Public _RmDS, _RmES, _RmFS, _RmGS
Public _RmRegs

_RmDS    dw 0                   ;Valor dos registos de segmento
_RmES    dw 0                   ;em modo real
_RmFS    dw 0
_RmGS    dw 0    
              
_RmRegs  DpmiRegisters <>         ;Registos de modo real
                                  
;-------------------------------------------------------------------

EndSegment32
End
