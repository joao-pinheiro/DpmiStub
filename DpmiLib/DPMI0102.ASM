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
; Redimensiona 1 bloco de mem alocado
; Retorna: Eax -> flag de estado                    
;                     
;---------------------------------------------------------------------
Public _DpmiResizeDosMem
                                                        
_DpmiResizeDosMem Proc Near
                Arg @select:dword,@newSize:dword
                                                          
             If PreserveRegsOnCall                        
                Push Ebx Edx
             EndIf                                        
                Mov eax,102h
                Mov edx,@select
                mov ebx,@newSize
                int 31h                         
                mov eax,0       
                setnc al        
                                
            @@Quit:             
             If PreserveRegsOnCall 
                Pop Edx Ebx
             EndIf              
                ret             
                                
             EndP              
                                   
EndSegment32               
End                        
