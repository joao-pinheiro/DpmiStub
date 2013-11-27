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
;Abre 1 Ficheiro
;Retorna EAX -> Handle ou 0
;--------------------------------------------------------------------

Public _FOpen
_FOpen Proc Near
       Arg @SelNome:Dword, @OfsNome:Dword,@Modo:dword

       If PreserveRegsOnCall
          Push Ecx Edx Esi Edi es
       EndIf
          mov es,word ptr @selNome
          mov edi,@ofsNome
          mov esi,@ofsNome
          mov ecx,-1
          xor eax,eax
          cld
          repne scasb
          neg ecx
          dec ecx
          cmp ecx,_DosLibBufSize
          jg @@Erro

          xor edi,edi
          push ds es
          mov es,_DosLibBufSel
          pop ds
          rep movsb
          pop ds

          mov eax,@modo
          mov ah,3dh
          mov dx,_DosLibBufSeg
          mov _RmDS,dx
          xor edx,edx
          call _ExecRmInt,21h
          jc @@erro
          jmp @@quit

       @@Erro:
          xor Eax,Eax

       @@Quit:
       If PreserveRegsOnCall
          Pop es edi esi edx ecx
       EndIf
          ret
      EndP


EndSegment32
End