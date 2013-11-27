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
; Seta o vector de interrup‡Æo de modo real
; Retorna: nada
;                                                  
;---------------------------------------------------------------------
Public _DpmiSetRmIntVec                            
                                                        
_DpmiSetRmIntVec Proc Near                         
                Arg @int:dword, @Segm:dword,@Ofs:dword
                                                          
             If PreserveRegsOnCall                        
                Push Ebx Eax Ecx Edx
             EndIf                                        
                Mov eax,201h        
                mov ebx,@int        
                mov ecx,@segm       
                mov edx,@ofs        
                int 31h                               
                                    
            @@Quit:                 
             If PreserveRegsOnCall  
                Pop Edx Ecx Eax Ebx         
             EndIf                  
                ret                 
                                
             EndP              
                                   
EndSegment32               
End                        
