;####################################################################
;
; Dpmi Stub Loader v1.0b
; 
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
; 
; Exemplo 1
;
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

_DpmiGetMem Proc
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

Public _Main
Extrn _Dump:Far

FileName Db 'c:\dump.dmp',0
ErroMsg  db 'Erro',0dh,0ah,'$'
Handle    dw 0
MemAddx   dd 0
Routine  dd 0,0
Align 16

Bufa:  Retf

       db 10000 dup(0)

_Main Proc
       Mov Edx,65535
       Call _DpmiGetMem,EDx
       Mov MemAddx,Edi

       mov ax,3d00h
       mov edx,offset  FileName
       int 21h
       jc @QuitErro
       mov Handle,ax

       mov ds,_SelData32
       mov ax,3f00h
       mov edx,offset bufa
       mov ecx,4096
       mov bx,handle
;       int 21h
;       jc @quitErro

       mov edx,Text32
       mov ebx,offset Bufa
       shl edx,4
       add edx,ebx
       mov ecx,edx
       shr ecx,16
       mov bx,_SelData0
       mov ax,07h
       int 31h
       jc @QuitErro
       Mov bx,_SelCode0
       int 31h
       jc @QuitErro
;       xor edi,edi
;       movzx ebx,bx
;       mov routine+4,ebx
;       Mov ebx,offset Routine


        Movzx Edx,_SelCode32
        Mov Ebx, offset @Quit
        push edx
        push ebx

        Movzx Edx,_SelCode0
        Mov Ebx, offset Bufa
        push edx
        push ebx
        Retf

;       jmp @quit

@QuitErro:
       mov edx,offset ErroMsg
       mov ah,09h
       int 21h
@quit:
       ret
       Endp     
                
EndSegment32          
end             
