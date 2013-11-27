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
; Seta o handler da exception
; Retorna: Eax -> Flag de Estado
;                                                        
;---------------------------------------------------------------------
Public _DpmiSetException
                        
_DpmiSetException Proc Near                         
                Arg @excp:dword,@selector:dword,@ofset:dword
                                                          
             If PreserveRegsOnCall                        
                Push Ebx Ecx Edx
             EndIf                                        
                Mov eax,203h    
                mov ebx,@excp
                mov Ecx,@Selector
                mov Edx,@Ofset   
                int 31h                         
                mov eax,0     
                setnc al      

            @@Quit:             
             If PreserveRegsOnCall 
                Pop Edx Ecx Ebx
             EndIf              
                ret             
                                
             EndP              
                                   
EndSegment32               
End                        
