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
; Liberta Bloco de mem¢ria do DOS alocado
; Retorna: Eax -> flag de estado                    
;                     
;---------------------------------------------------------------------
Public _DpmiFreeDosMem
                                                        
_DpmiFreeDosMem Proc Near
                Arg @select:dword
                                                          
             If PreserveRegsOnCall                        
                Push Edx   
             EndIf                                        
                Mov eax,101h
                Mov edx,@select
                int 31h
                mov eax,0
                setnc al

            @@Quit:            
             If PreserveRegsOnCall 
                Pop Edx
             EndIf             
                ret            
                               
             EndP              
                                   
EndSegment32               
End                        
