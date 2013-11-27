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
; Devolve o selector de 1 descriptor q mapeia o segmento
; Retorna: Ax-> Selector ou 0                                                                    
;                                                                     
;---------------------------------------------------------------------
Public _DpmiSegment2Descriptor
                                  
_DpmiSegment2Descriptor Proc Near
                Arg @Segm:dword  

             If PreserveRegsOnCall
                Push Ebx
             EndIf       
                mov ax,02h
                mov ebx,@segm
                int 31h
                jc @@Erro
                Jmp @@Quit 
                         
             @@Erro:     
                xor eax,eax     
                         
             @@Quit:                                 
             If PreserveRegsOnCall
                Pop Ebx
             EndIf       
                ret      
                         
             EndP
                                   
EndSegment32
End
