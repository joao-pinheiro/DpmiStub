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
; Devolve o handler da exception
; Retorna: cx:edx -> Selector:ofs do handler da exception
;          Eax -> Flag de Estado
;                                                        
;---------------------------------------------------------------------
Public _DpmiGetException
                        
_DpmiGetException Proc Near                         
                Arg @excp:dword
                                                          
             If PreserveRegsOnCall                        
                Push Ebx
             EndIf                                        
                Mov eax,202h
                mov ebx,@excp
                int 31h                         
                mov eax,0
                setnc al
                        
            @@Quit:             
             If PreserveRegsOnCall 
                Pop Ebx
             EndIf              
                ret             
                                
             EndP              
                                   
EndSegment32               
End                        
