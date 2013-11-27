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
; devolve o vector de interrup‡Æo de modo protegido
; Retorna: cx:edx -> Selector:ofs do handler de modo protegido
;                                                            
;---------------------------------------------------------------------
Public _DpmiGetPmIntVec                                      
                                                             
_DpmiGetPmIntVec Proc Near                                   
                Arg @int:dword                               
                                                             
             If PreserveRegsOnCall                           
                Push Ebx Eax                                 
             EndIf                                           
                Mov eax,204h                                 
                mov ebx,@int
                int 31h                         
                            
            @@Quit:             
             If PreserveRegsOnCall 
                Pop Eax Ebx     
             EndIf              
                ret             
                                
             EndP              
                                   
EndSegment32               
End                        
