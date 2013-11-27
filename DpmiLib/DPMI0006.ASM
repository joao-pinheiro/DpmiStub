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
; Devolve a Base de 1 Descriptor
; Retorna: Edi-> Endere‡o linear da base do descriptor
;                                                                     
;---------------------------------------------------------------------
Public _DpmiGetBase                                   
                                                      
_DpmiGetBase Proc Near                                
             Arg @Select:dword
                          
             If PreserveRegsOnCall
                Push Eax Ebx Ecx Edx
             EndIf                  
                Mov eax,06h         
                mov ebx,@select     
                int 31h             
                jc @@Erro
                Movzx Edi,cx
                shl edi,16
                mov di,dx
                Jmp @@Quit 
                         
             @@Erro:     
                xor edi,edi
                                   
             @@Quit:                                 
             If PreserveRegsOnCall 
                Pop Edx Ecx Ebx Eax
             EndIf         
                ret        
                           
             EndP
                                   
EndSegment32
End
