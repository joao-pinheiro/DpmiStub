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
; Retorna o tamanho da p gina
; Retorna Eax -> Tamanho da p gina em bytes ou 0
;                                          
;---------------------------------------------------------------------
Public _DpmiGetPageSize                    
                                                         
_DpmiGetPageSize Proc Near                  
                           
             If PreserveRegsOnCall
                push ebx ecx
             EndIf                  
                mov eax,604h
                int 31h             
                jc @@error                    
                mov ax,bx
                shl eax,16
                mov ax,cx
                jmp @@quit
                
             @@Error:
                xor eax,eax
                
             @@quit:
             If PreserveRegsOnCall
                pop ecx ebx
             EndIf                  
                ret            
             EndP                 

                                   
EndSegment32                      
End                               
