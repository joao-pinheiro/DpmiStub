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
; Aloca 1 Bloco de mem¢ria                                                                     
; Retorna: Edi-> novo bloco ou Nil                                                                    
;                                                                     
;---------------------------------------------------------------------
Public _DpmiGetMem         

_DpmiGetMem Proc Near                                                      
            arg @Size:Dword                                   
                                                              
         If PreserveRegsOnCall
            Push eax ebx ecx edx esi es
         EndIf              
            mov es,_SelData0
            Mov ebx,@Size                                     
            mov cx,bx                                         
            Shr ebx,16                                        
            add ebx,4                           ;adiciona espa‡o 
            mov ax,0501h                                        
            int 31h                                           
            jc @@Error                     
                     
            shl Esi,16                          ;Handle em Esi
            mov si,di
            shl ebx,16                          ;Addx em ebx
            mov bx,cx                                       
            mov edi,ebx                         ;retorna edi
            mov es:[edi],esi                    ;guarda o handle
            add edi,4 
            jmp @@Quit        
                              
       @@Error:               
            Mov edi,nil                         ;retorna com nil          
                      
       @@Quit:                  
         If PreserveRegsOnCall
            Pop es esi edx ecx ebx eax
         EndIf                     
            ret                    
                                   
           EndP                    
                                   
EndSegment32
End
