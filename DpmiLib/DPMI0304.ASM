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
; Liberta o callback address alocado
;                   
;---------------------------------------------------------------------
Public _DpmiFreeCallBack                                
                                                         
_DpmiFreeCallBack Proc
                Arg @rmseg:dword,@rmofs:dword
                                             
             If PreserveRegsOnCall
                Push Eax Ecx Edx
             EndIf              
                Mov eax,0304h   
                mov ecx,@rmseg  
                mov edx,@rmofs  
                int 31h         

             @@Quit:                                 
             If PreserveRegsOnCall
                Pop Edx Ecx Eax
             EndIf                
                ret               
                                  
             EndP                 
                                   
EndSegment32                      
End                               
