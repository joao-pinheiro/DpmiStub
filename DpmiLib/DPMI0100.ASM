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
; Aloca 1 Bloco de mem¢ria do DOS
; Retorna: Eax -> Segmento de modo real ou 0        
;          Edx -> Selector q mapeia o bloco ou 0                      
;---------------------------------------------------------------------
Public _DpmiGetDosMem
                                                        
_DpmiGetDosMem Proc Near
               Arg @paragr:dword
                                                          
             If PreserveRegsOnCall                        
                Push Ebx
             EndIf                                        
                Mov eax,100h
                Mov ebx,@paragr
                int 31h
                jc @@erro
                jmp @@quit

            @@Erro:              
                xor eax,eax
                xor edx,edx
            @@Quit:            
             If PreserveRegsOnCall 
                Pop Ebx
             EndIf             
                ret            
                               
             EndP              
                                   
EndSegment32               
End                        
