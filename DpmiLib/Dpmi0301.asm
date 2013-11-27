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
; Chama 1 rotina em rm com far return                                                                    
; Parƒmetros:
;   SelStruc:OfsStruc -> addx da estrutura de registos
;   Words2Copy-> words a copiar entre stacks   
; Retorna:
;  ax -> True/False                                                                    
;---------------------------------------------------------------------
Public _DpmiCallRmProc
                                
_DpmiCallRmProc Proc Near
            Arg @SelStruc:Dword,@OfsStruc:Dword,@Words2Copy:dword
                                
         If PreserveRegsOnCall
            Push Ebx Ecx Edi es
         EndIf                         
            mov ecx,@words2copy 
            mov es,word ptr @SelStruc
            mov edi,@OfsStruc
            mov ax,0301h      
            xor bx,bx         
            int 31h           
            setnc al          
            cbw               
         If PreserveRegsOnCall 
            Pop es Edi Ecx Ebx
         EndIf                         
            Ret
          EndP
                                   
EndSegment32
End
