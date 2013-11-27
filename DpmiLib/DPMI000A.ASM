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
; Cria 1 selector de dados alias do @select de c¢digo
; Retorna: Eax-> Novo Selector ou 0                     
;                                                                     
;---------------------------------------------------------------------
Public _DpmiCreateAlias            
                                                        
_DpmiCreateAlias Proc Near         
             Arg @Select:dword     
                                                       
             If PreserveRegsOnCall        
                Push Ebx
             EndIf                        
                Mov eax,00Ah
                mov ebx,@select 
                int 31h     
                Jc @@Erro 
                Jmp @@Quit  
                         
            @@Erro:                
                Xor eax,eax
                         
            @@Quit:         
             If PreserveRegsOnCall 
                Pop Ebx  
             EndIf             
                ret            
                               
             EndP              
                                   
EndSegment32 
End          
