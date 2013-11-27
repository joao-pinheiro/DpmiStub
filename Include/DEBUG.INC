
comment %                                                        
DumpAllHeap Proc 
       arg @From:Dword    
       
       mov edi,@from
       xor edx,edx
    @DumpLoop:          
       inc edx
       call DumpBlock,Edi
       mov ecx,[edi+4]
       add ecx,16 
       add edi,ecx
       cmp edx,25
       jge @quitdump
       cmp edi,_HeapTop
       jb @DumpLoop             

   @quitdump:                 
       call dumpvalue,_HeapHead
       ret          
     Endp          
                                                                     
;-------------------------------------------------------------                                                                     
LivreStr   Db 'Bloco Livre------------------------',0dh,0ah   
           db 'Endere‡o: ' 
LivreAddx  db '0000000h',0,0dh,0ah 
           db 'Next: '                            
LivreNext  db '0000000h',0,0dh,0ah                
           db 'Size: '                            
LivreSize  db '0000000h',0,0dh,0ah                
           db 'Prev: '                            
LivrePrev  db '0000000h',0,0dh,0ah                
           db 'Prev Free: '                       
LivrePrev2 db '0000000h',0,0dh,0ah                
           db '$'                                 
                                                  
UsedStr    Db 'Bloco Alocado----------------------',0dh,0ah
           db 'Endere‡o: '
UsedAddx   db '0000000h',0,0dh,0ah           
           db 'Size: '                            
UsedSize   db '0000000h',0,0dh,0ah                
           db 'Prev: '                            
UsedPrev   db '0000000h',0,0dh,0ah                
           db '$'                                 
                        
;-------------------------------------------------------------                               
ShowBlocoLivre Proc
         arg @Bloco:dword
           
         push eax edi edx
         mov edi,@bloco
         mov esi,offset LivreAddx
         Call Int2Str,edi,esi   
         mov edx,[edi][FreeBlock.NextBlock]
         mov esi,offset LivreNext
         Call Int2Str,edx,esi   
         mov edx,[edi][FreeBlock.BlockSize]
         mov esi,offset LivreSize                                    
         Call Int2Str,edx,esi
         mov edx,[edi][FreeBlock.PrevBlock]
         mov esi,offset LivrePrev    
         Call Int2Str,edx,esi                   
         mov edx,[edi][FreeBlock.PrevFreeBlock]
         mov esi,offset LivrePrev2       
         Call Int2Str,edx,esi            
         mov edx,offset LivreStr
         mov ah,09h      
         int 21h         
         pop edx edi eax 
         ret             
       EndP                                                              
                                                                     
ShowBlocoOcupado Proc
         arg @Bloco:dword
                                
         push eax edi edx
         mov edi,@bloco  
         mov esi,offset UsedAddx
         Call Int2Str,edi,esi   
         mov edx,[edi][AllocBlock.BlockSize]
         mov esi,offset UsedSize 
         Call Int2Str,edx,esi    
         mov edx,[edi][AllocBlock.PrevBlock]
         mov esi,offset UsedPrev                
         Call Int2Str,edx,esi        
         mov edx,offset UsedStr
         mov ah,09h      
         int 21h         
         pop edx edi eax 
         ret             
       EndP                                                              

DumpBlock proc
         arg @Bloco:dword
         
         mov edi,@bloco
         cmp dword ptr [edi],MemBlockID
         je @Dump_Used
         call ShowBlocoLivre,edi
         jmp @zquit
         
       @Dump_used:
         call ShowBlocoOcupado,edi
       @zquit:                                  
         Ret
       endp  
;----------------------------------------------------                
         %                                                            
;--------------------------------------------------------------------
;Rotinas de Conversao de binario pra String--------------------------
                                                                     
BaseNumber  dd 16         ;Base do Num a ser convertido para string
FieldLen    dw 8          ;Tamanho do Campo
PadChar     db '0'        ;Caracter de PAD
Suffix      db 'h'        ;Sufixo
                 
;--------------------------------------------------------------------
;Converte um numero inteiro numa string
;--------------------------------------------------------------------
                            
Int2Str Proc Near          
        Arg @n:dword, @so:dword                                      
                                                                     
        uses eax,ebx,ecx,edx,esi,edi,es         
        mov es,cs:_SelData32                    ;string de destino
        mov edi,@so                             ;em text32
        mov eax,@n
        movzx edx,fieldlen                      ;posiciona-se no fim
        add edi,edx
        mov dl,suffix
        mov byte ptr [edi],dl                   ;poe o sufixo
        mov ecx,baseNumber

   @@MainLoop:
        dec edi
        xor edx,edx
        div Ecx
        add dl,'0'
        mov byte ptr [edi],dl
        cmp dl,'9'
        jbe @@MainLoop1    
        add byte ptr [edi],7                                         
                          
   @@MainLoop1:                                 
        cmp edi,@so                             ;esgotou o n de caracteres
        je @@IntQuit                            ;disponiveis na string?
        cmp eax,0                               ;chegamos ao fim?
        jne @@MainLoop
  
   @@IntLoop2:                                  ;preenche o restante
        mov al,padchar                          ;com pad
        mov ecx,@so
        sub edi,ecx                             ;quantos faltam?
        xchg edi,ecx
        cld
        rep stosb

   @@IntQuit:
        ret
               
     Endp                  
                                                                     
;--------------------------------------------------------------------
;Rotinas de Dump dos Registos----------------------------------------
                                 
DumpValueS db '0000000h',0,0,0dh,0ah,'$'
          
;--------------------------------------------------------------------
;Exibe no ecra os valores dos registos salvos no stack frame
;--------------------------------------------------------------------

DumpValue proc near
         arg @num:dword
                                 
        push eax ebx ecx edx edi esi es ds
        mov BaseNumber,16                       ;Seta os parametros de
        Mov FieldLen,8                          ;conversao numerica
        Mov PadChar,48               
        mov eax,@num                 
        mov edi,offset DumpValueS    
        Call Int2Str,eax,edi         
        mov edx,offset DumpValueS                                    
        mov ah,09h                   
        int 21h                                 
        pop ds es esi edi edx ecx ebx eax
        ret
        
      Endp
