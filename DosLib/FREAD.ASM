;####################################################################
;
; Dpmi Stub Loader v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000
;
;
;####################################################################

.model large,pascal
.386p
Locals

Include ..\include\Segs.Inc
Include ..\include\Stub.inc
Include ..\include\Defs.Inc
Include ..\include\DpmiLib.Inc

  Segment32

Global _DosLibBufSeg:Word
Global _DosLibBufSel:Word
Global _DosLibBufSize:Dword

;--------------------------------------------------------------------
;Lˆ x bytes do file pra dest
;Retorna -> Eax - Estado
;--------------------------------------------------------------------

Public _FRead
_FRead Proc Near
        Arg @Handle:dword,@SelDest:Dword,@OfsDest:dword,@count:dword

       If PreserveRegsOnCall
          Push Ebx Ecx Edx Esi Edi es
       EndIf
          mov ebx,_DosLibBufSize
          mov Eax,@Count
          xor edx,edx
          Div ebx                     ;Eax - Blocos a copiar/Edx-Resto
          push Edx                    ;salva o resto
          mov ecx,eax                 ;vezes do 1§ loop
          mov edi,@OfsDest            ;destino
          mov es, word ptr @SelDest   ;destino em es:edi
          Mov ebx,@handle
          mov dx,_DosLibBufSeg        ;buffer em rmds:dx
          mov _RmDS,dx
          mov si,_DosLibBufSel
          xor edx,edx                 ;buffer em ds:si
          jecxz @@StartLoop2          ;se bloco a ler < dosbufsize

     @@Loop_1:
          Push Ecx edi                ;salva contador/destino
          Mov ecx,_DosLibBufSize      ;bytes a ler de cada vez
          Call ReadFromFile           ;lˆ do file pro buffer
          pop edi ecx                 ;restaura regs
          jc @@error_loop1            ;se leu houve erro aborta
          add edi,eax                 ;se nÆo, incrementa destino
          Loop @@Loop_1               ;at‚ copiar ecx blocos

     @@StartLoop2:
          mov eax,1                   ;se sair, sai com eax=1
          Pop Ecx                     ;vˆ o resto
          jecxz @@quit                ;se for 0, sai
          call ReadFromFile           ;lˆ os bytes q faltam
          jc @@error                  ;se houve bronca retorna
          mov eax,1                   ;sai com eax a 1 (correu Bem)
          jmp @@quit

     @@error_Loop1:
          pop eax

     @@Error:                           ;sai com eax a 0 (erro)
          xor eax,eax
     @@Quit:
     If PreserveRegsOnCall
          Pop es Edi Esi Edx Ecx Ebx
       EndIf
        ret
      EndP
;-----------------------------------------------------------------------
; lˆ do fich BX CX bytes para ds:dx e copia-los pra Es:edi

ReadFromFile:
        mov eax,3f00h                         ;fun‡Æo de leitura com hanlde
        call _ExecRmInt,21h                   ;executa
        jc @@ReadQuit                         ;se correu mal, sai
        push ds esi                           ;salva ds
        mov ds,si
        xor esi,esi                           ;limpa origem
        cmp cx,ax
        jne @@ReadError                       ;se nÆo leu tudo d  erro
        cld
        rep movsb                             ;copia byte a byte (nÆo ‚ eficiente)
        pop esi ds                            ;restaura DS
  @@ReadQuit:
        ret                                   ;retorna ao chamador

  @@ReadError:
        pop esi ds
        stc
        ret


EndSegment32
End