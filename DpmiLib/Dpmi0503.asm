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
; Redimensiona o Bloco de mem¢ria alocado                                                                    
; Retorna: Edi-> novo bloco ou Nil                                                                    
;                                                                     
;---------------------------------------------------------------------
Public _DpmiResizeMem 
                                                                      
_DpmiResizeMem Proc Near                                                  
               Arg @Bloco:Dword,@size:dword
               
           If PreserveRegsOnCall
              Push esi ebx ecx eax es
           EndIf                                                
              mov es,_SelData0                                  
              mov edi,@Bloco         
              mov esi,es:[edi-4]                ;recupera o handle
              mov di,si              
              shr esi,16                        ;em si:di
              mov ebx,@size          
              mov cx,bx                         ;novo tamanho
              shr ebx,16                        ;em bx:cx
              add ebx,4              
              mov ax,0503h           
              int 31h                
              jc @@Erro              
              shl esi,16                        ;o handle em si:di
              mov si,di                                           
              shl ebx,16                        ;o addx em bx:cx
              mov bx,cx                                         
              mov edi,ebx                                       
              mov es:[edi],esi                  ;guarda o handle
              add edi,4                                         
              jmp @@quit             
                                                                
           @@Erro:                                              
              mov edi,nil                       ;retorna nil
                                     
           @@Quit:                   
           If PreserveRegsOnCall     
              Pop es eax ecx ebx esi
           EndIf                     
              Ret                    
                                     
            EndP                     
                                   
EndSegment32
End
