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
; Aloca Count Descriptors na LDT                                                                    
; Retorna: Ax-> Selector Base ou 0                                                                    
;                                                                     
;---------------------------------------------------------------------
Public _DpmiAllocDescriptors      
                                  
_DpmiAllocDescriptors Proc        
                Arg @Count:dword  

             If PreserveRegsOnCall
                Push Ecx
             EndIf       
                Mov ecx,@count
                xor ax,ax
                int 31h  
                jc @@Erro
                Jmp @@Quit 
                         
             @@Erro:     
                xor ax,ax     
                         
             @@Quit:                                 
             If PreserveRegsOnCall
                Pop Ecx
             EndIf       
                ret      
                         
             EndP
                                   
EndSegment32
End
