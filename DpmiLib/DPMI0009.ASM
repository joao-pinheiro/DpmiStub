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
; Seta os bytes de Access Rights do descriptor
; AcessR -> 386 extended rights/type byte
; Retorna: Eax-> Flag de estado                         
;                                                                     
;---------------------------------------------------------------------
Public _DpmiSetAccessR                     
                                                        
_DpmiSetAccessR Proc Near                  
             Arg @Select:dword,@AcessR:Dword
                                          
             If PreserveRegsOnCall        
                Push Ebx Ecx
             EndIf                        
                Mov eax,09h     
                mov ebx,@select 
                mov ecx,@AcessR
                int 31h     
                mov eax,0   
                setnc al    
                            
            @@Quit:         
             If PreserveRegsOnCall 
                Pop Ecx Ebx
             EndIf             
                ret            
                               
             EndP              
                                   
EndSegment32 
End          
