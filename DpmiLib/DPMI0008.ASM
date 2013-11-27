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
; Seta o Limite de 1 Descriptor
; Retorna: Eax-> Flag de estado                         
;                                                                     
;---------------------------------------------------------------------
Public _DpmiSetLimit                                     
                                                        
_DpmiSetLimit Proc Near
             Arg @Select:dword,@Lim:Dword
                                          
             If PreserveRegsOnCall        
                Push Ebx Ecx Edx
             EndIf                        
                Mov eax,08h
                mov ebx,@select
                mov ecx,@Lim
                mov dx,cx
                shr ecx,16
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
