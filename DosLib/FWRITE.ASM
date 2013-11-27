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
;Escreve Count Bytes do Buffer para o ficheiro
;Retorna -> Eax - Estado
;--------------------------------------------------------------------
Public _Fwrite

_FWrite Proc Near
        Arg @Handle:dword,@SelSrc:Dword,@OfsSrc:dword,@count:dword

       If PreserveRegsOnCall
          Push Ebx Ecx Edx Esi Edi es
       EndIf
          mov ebx,_DosLibBufSize
          mov Eax,@Count
          xor edx,edx
          Div ebx                     ;Eax - Blocos a copiar/Edx-Resto
          push Edx                    ;salva o resto
          mov ecx,eax                 ;vezes do 1§ loop
          mov esi,@OfsSrc             ;origem
          mov di, word ptr @SelSrc    ;origem em di:esi
          mov es,_DosLibBufSel        ;destino em es:edi(buffer)
          Mov ebx,@handle
          mov dx,_DosLibBufSeg        ;buffer em rmds:dx
          mov _RmDS,dx
          xor edx,edx                 ;buffer em ds:si
          jecxz @@StartLoop2          ;se bloco a ler < dosbufsize

     @@Loop_1:
          Push Ecx esi                ;salva contador/destino
          Mov ecx,_DosLibBufSize      ;bytes a ler de cada vez
          Call WriteToFile            ;escreve do buffer pro file
          pop esi ecx                 ;restaura regs
          jc @@error_loop1            ;se leu houve erro aborta
          add esi,eax                 ;se nÆo, incrementa destino
          Loop @@Loop_1               ;at‚ copiar ecx blocos

     @@StartLoop2:
          mov eax,1                   ;se sair, sai com eax=1
          Pop Ecx                     ;vˆ o resto
          jecxz @@quit                ;se for 0, sai
          call WriteToFile            ;escreve os bytes q faltam
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
; escreve no fich BX CX bytes de ds:dx / Es:edi

WriteToFile:
        push edi ds ecx
        mov ds,di
        xor edi,edi
        cld
        rep movsb
        pop ecx ds edi
        mov eax,4000h                         ;fun‡Æo de escrita com handle
        call _ExecRmInt,21h                   ;executa
        jc @@WriteQuit
        cmp cx,ax                             ;se nÆo escreveu tudo d  erro
        je @@WriteQuit
        stc
  @@WriteQuit:
        ret                                   ;retorna ao chamador



EndSegment32
End