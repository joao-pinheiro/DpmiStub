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
; Seta o descriptor do selector
; Retorna: Eax -> Flag de Estado                     
;                                                                     
;---------------------------------------------------------------------
Public _DpmiSetDescr
                                                        
_DpmiSetDescr Proc Near
             Arg @Select:dword,@TgtSel:dword,@TgtOfs:Dword
                                                          
             If PreserveRegsOnCall                        
                Push Ebx Edi es                                  
             EndIf                                        
                Mov eax,00Ch
                mov ebx,@select
                Mov edi,@tgtsel
                mov es,di      
                mov edi,@tgtOfs
                int 31h        
                mov eax,0
                setnc al 
                               
            @@Quit:            
             If PreserveRegsOnCall 
                Pop es Edi Ebx
             EndIf             
                ret            
                               
             EndP              
                                   
EndSegment32               
End                        
