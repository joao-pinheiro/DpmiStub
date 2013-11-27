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
; Liberta 1 descriptor alocado                                                                    
; retorna: AX -> Verdadeiro/Falso
;                                                                     
;---------------------------------------------------------------------
Public _DpmiFreeDescriptor       
                                 
_DpmiFreeDescriptor Proc Near        
                Arg @Selector:Dword
                                 
             If PreserveRegsOnCall
                push ebx                 
             EndIf               
                mov ax,01h          
                mov ebx,@Selector
                int 31h 
                setnc al
                cbw
             If PreserveRegsOnCall
                pop ebx
             EndIf               
             ret                 
                       
           EndP             
                                   
EndSegment32
End
