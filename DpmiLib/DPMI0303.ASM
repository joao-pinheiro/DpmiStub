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
; Aloca um callback address                                                                    
; Retorna: cx:dx -> seg:ofs do addx de modo real a chamar ou 0
;                   
;---------------------------------------------------------------------
Public _DpmiAllocCallBack                                
                                                         
_DpmiAllocCallBack Proc                               
                Arg @Sel2Call:dword,@Ofs2Call:dword,@rmstrucsel:dword,@rmstrucOfs:dword
                      
             If PreserveRegsOnCall
                Push Eax Esi Edi es
             EndIf              
                push ds        
                Mov eax,0303h  
                mov esi,@sel2Call
                mov edi,@rmstrucsel
                mov ds,si      
                mov es,di      
                mov esi,@Ofs2Call
                mov edi,@rmstrucOfs
                int 31h
                pop ds                                        
                jc @@Erro
                Jmp @@Quit 
                         
             @@Erro:     
                xor ecx,ecx
                xor edx,edx
                           
             @@Quit:                                 
             If PreserveRegsOnCall
                Pop Es Edi Esi Eax
             EndIf                
                ret               
                                  
             EndP                 
                                   
EndSegment32                      
End                               
